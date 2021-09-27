//
//  TableViewCellType.swift
//  DPS
//
//  Created by Gaurang on 23/09/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit

enum TableViewCellType: String {
    case trip       = "TripTableViewCell"
    case noData     = "NoDataFoundTblCell"
    var cellId: String {
        switch self {
        case .trip:
            return "trip_cell"
        case .noData:
            return "no_data_cell"
        }
    }
}

extension UITableView {
    func registerNibCell(type: TableViewCellType) {
        self.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.cellId)
    }
}
