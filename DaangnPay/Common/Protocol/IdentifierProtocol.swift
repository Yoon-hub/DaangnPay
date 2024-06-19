//
//  IdentifierProtocol.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/14/24.
//

import UIKit

protocol IdentifierProtocol {
    static var identifier: String { get }
}

extension IdentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: IdentifierProtocol {}
