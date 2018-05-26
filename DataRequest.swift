

import Foundation
enum Response {
    case success(data:Data)
    case failure(error:String,message:String)
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    public var isFailure: Bool {
        return !isSuccess
    }
    public var result: Data? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}

class DataRequest {
    static func post(url:String,method:String = "POST",param:[String:Any]?,
                     completion:@escaping (Response)->Void){
        guard let url = URL(string: url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = method
        for (key,value) in URLs.headers{
            request.setValue(value, forHTTPHeaderField: key)
        }
        print(url,URLs.headers)
        if let param = param{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error: "param error", message: error.localizedDescription))
                }
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let mError = error{
                let msg:String = {
                    if let err = mError as? URLError,
                        err.code == .notConnectedToInternet {
                        return Const.networkError
                    } else {
                        return Const.wentWrong
                    }
                }()
                DispatchQueue.main.async {
                    completion(.failure(error: mError.localizedDescription, message: msg))
                }
                
            }else if let mData = data{
                DispatchQueue.main.async {
                    completion(.success(data: mData))
                }
                
            }
        }
    
        task.resume()
    }
    static func get(url:String,param:[String:String]? = nil,completion:@escaping (Response)->Void){
        var urlString = url
        if let param = param{
            for (key,value) in param {
                urlString.append("&\(key)=\(value)")
            }
        }
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key,value) in URLs.headers{
            request.setValue(value, forHTTPHeaderField: key)
        }
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let mError = error{
                let msg:String = {
                    if let err = mError as? URLError,
                        err.code == .notConnectedToInternet {
                        return Const.networkError
                    } else {
                        return Const.wentWrong
                    }
                }()
                DispatchQueue.main.async {
                    completion(.failure(error: mError.localizedDescription, message: msg))
                }
            }else if let mData = data{
                DispatchQueue.main.async {
                    completion(.success(data: mData))
                }
            }
        }
        task.resume()
    }
    
    static func responseCodable<T: Codable>(data:Data) -> Model<T>?{
        do{
            let info = try JSONDecoder().decode(Model<T>.self, from: data)
            return info
        }catch(let error){
            print(error)
            return nil
        }
    }
}
