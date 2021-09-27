//
//  RestClient.swift
//  MVVMDemo
//
//  Created by Gaurang on 02/09/21.
//

import Foundation
import Moya

enum RestResult<C: Codable> {
    case success(data: C)
    case error(error: String, retry: Bool)
}

class RestClient {
    static let shared = RestClient()

    func parseJson<C: Codable>(response: Result<Moya.Response, MoyaError>) -> RestResult<C> {
        switch response {
        case .success(let result):
            do {
                let info = try JSONDecoder().decode(C.self, from: result.data)
                return .success(data: info)
            } catch {
                return .error(error: Messages.somethingWentWrong, retry: false)
            }
        case .failure(let error):
            guard let statusCode = error.response?.statusCode,
                  let message = Messages.getMessageFromStatusCode(statusCode) else {
                return .error(error: Messages.somethingWentWrong, retry: false)
            }
            return .error(error: message, retry: false)
        }
    }

    func getUserList(page: Int, completion: @escaping (_ result: RestResult<UsersModel>) -> Void) {
        UserServices.provider.request(.userList(page: page)) { response in
            completion(self.parseJson(response: response))
        }
    }
}
