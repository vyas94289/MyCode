import Foundation

protocol Convertable: Encodable {

}

extension Convertable {

    // implement convert Struct or Class to Dictionary
    func convertToDict() -> Dictionary<String, Any>? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        } catch {
            print(error)
        }
        return nil
    }

    func convertToJsonData() -> Data? {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(self)
        } catch {
            print(error)
        }
        return nil
    }
}

// MARK: - Request model
struct LoginRequestModel: Convertable {
    let email, password: String
}

// MARK: - Models
import Foundation
struct BaseResponseModel<T: Codable>: Codable {
    let status: Bool
    let message: String?
    let data: T?
}

struct LoginModel: Codable {
    let userId: String
}

// API Service

import Foundation

enum WSPaths: String {
    case auth
    case posts
}

enum WSApi: String {
    case login
    case postList = "post_list"
}

extension WSApi {
    var path: WSPaths {
        switch self {
        case .login:
            return .auth
        case .postList:
            return .posts
        }
    }

    var url: URL {
        return URL(string: "\(AppEnvironment.hostURL)\(path.rawValue)/\(rawValue)")!
    }

    func addCommonHeaders(to request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        switch self {
        case .login:
            request.addValue("DPS$951", forHTTPHeaderField: "key")
        default:
            request.addValue(SessionManager.shared.apiToken, forHTTPHeaderField: "x-api-key")
        }
    }
}

enum WSHeaderField {
    static func addCommonHeaders(to request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}

enum HttpMethod: String {
    case get    = "GET"
    case post   = "POST"
}

enum AppError: Error {
    case decodingError
    case networkError
    case apiResponseError(String)
    case unknownError

    var message: String {
        switch self {
        case .decodingError, .unknownError:
            return Messages.somethingWentWrong
        case .networkError:
            return Messages.noInternetConnection
        case .apiResponseError(let error):
            return error
        }
    }

    var canRetry: Bool {
        switch self {
        case .networkError:
            return true
        default:
            return false
        }
    }

}

class ApiService {

    static let shared = ApiService()
    
    fileprivate func resumeDataTask<T: Codable>(_ request: URLRequest, _ completion: @escaping (Result<T, AppError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Api Error for \(request.url!.lastPathComponent): ", error.localizedDescription)
                    completion(.failure(.unknownError))
                }
            } else if let data = data {
                do {
                    let baseModel = try JSONDecoder().decode(BaseResponseModel<T>.self, from: data)
                    if baseModel.status, let model = baseModel.data {
                        DispatchQueue.main.async {
                            completion(.success(model))
                        }
                    } else if let message = baseModel.message {
                        DispatchQueue.main.async {
                            completion(.failure(.apiResponseError(message)))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(.unknownError))
                        }
                    }

                } catch(let error) {
                    DispatchQueue.main.async {
                        print("Api Error for \(request.url!.lastPathComponent): ", error.localizedDescription)
                        completion(.failure(.decodingError))
                    }
                }
            }
        }

        task.resume()
    }

    func postRequest<T: Codable>(api: WSApi, body: Data?, completion: @escaping (Result<T, AppError>) -> Void) {
        var request = URLRequest(url: api.url)
        api.addCommonHeaders(to: &request)
        request.httpMethod = HttpMethod.post.rawValue
        if let bodyData = body {
            request.httpBody = bodyData
        }
        resumeDataTask(request, completion)
    }

    func getRequest<T: Codable>(api: WSApi, params: [String: String] = [:], completion: @escaping (Result<T, AppError>) -> Void) {
        var urlComponents = URLComponents(string: api.url.absoluteString)!
        if !params.isEmpty {
            urlComponents.queryItems = params.compactMap({URLQueryItem(name: $0.key, value: String(describing: $0.value))})
        }
        guard let url = urlComponents.url else {
            return
        }
        var request = URLRequest(url: url)
        api.addCommonHeaders(to: &request)
        request.httpMethod = HttpMethod.get.rawValue
        resumeDataTask(request, completion)
    }

}

extension ApiService {
    func loginRequest(_ requestModel: LoginRequestModel, completion: @escaping (Result<LoginModel, AppError>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            postRequest(api: .login, body: requestModel.convertToJsonData(), completion: completion)
        } else {
            completion(.failure(.networkError))
        }
    }
}


// MARK: Usage

let requestModel = LoginRequestModel(email: "", password: "")
ApiService.shared.loginRequest(requestModel) { result in
     switch result {
     case .success(let model):
         break
     case .failure(let error):
         break
     }
 }
