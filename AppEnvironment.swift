//
//  AppEnvironment.swift
//  MVVMDemo
//
//  Created by Gaurang on 02/09/21.
//

import Foundation

enum AppEnvironment: String {
    case development
    case staging
    case production

    var hostUrl: String {
        switch self {
        case .development   :  return "https://dev.reqres.in/api/"
        case .staging       :  return "https://stage.reqres.in/api/"
        case .production    :  return "https://reqres.in/api/"
        }
    }

    var socketUrl: String {
        switch self {
        case .development   :  return "https://api.dev"
        case .staging       :  return "https://api.stage"
        case .production    :  return "https://api.dev"
        }
    }

    var stripeClientID: String {
        switch self {
        case .development:  return "ca_GLuMb6NBTUeWoltM2dfS5AbE7qXmkuqe"
        case .staging:      return "ca_GQ1hga2RyO6N1B0mGM2naOp8YXHE3aZc"
        case .production:   return "ca_GLuMb6NBTUeWoltM2dfS5AbE7qXmkuqe"
        }
    }
}

class Environment {
    static let shared = Environment()
    lazy var environment: AppEnvironment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "development") != nil {
                return AppEnvironment.development
            } else if configuration.range(of: "staging") != nil {
                return AppEnvironment.staging
            }
        }
        return AppEnvironment.production
    }()

    static var hostURL: String {
        Environment.shared.environment.hostUrl
    }

    static let stripeBaseURL = "https://stripe.com/docs/api"

    static var socketURL: String {
        Environment.shared.environment.socketUrl
    }

}
