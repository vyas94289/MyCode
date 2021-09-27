//
//  UserListViewModel.swift
//  MVVMDemo
//
//  Created by Gaurang on 02/09/21.
//

import Foundation

class UserListViewModel: BaseViewModel {

    var users: [UserInfo] = [] {
        didSet {
          changeHandler?(.updateDataModel)
        }
    }

    var changeHandler: ((BaseViewModelChange) -> Void)?

    func startSynching() {
        emit(.loaderStart)
        RestClient.shared.getUserList(page: 1) { result in
            switch result {
            case .success(let response):
                self.users = response.data ?? []
                self.emit(.updateDataModel)
            case .error(let error, let retry):
                self.emit(.error(message: error, retry: retry))
            }
        }
    }

    func emit(_ change: BaseViewModelChange) {
             changeHandler?(change)
    }

}
