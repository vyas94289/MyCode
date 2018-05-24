//
//  Model.swift
//  Ethnoshop
//
//  Created by Dhaval Patel on 02/05/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import Foundation
struct Model<T: Decodable>: Decodable {
    let success: Int?
    let error: [String]?
    let data:T?
    enum  CodingKeys:String, CodingKey{
        case success,error,data
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try? values.decode(Int.self, forKey: .success)
        error = try? values.decode([String].self, forKey: .error)
        data = try? values.decode(T.self, forKey: .data)
    }
}
