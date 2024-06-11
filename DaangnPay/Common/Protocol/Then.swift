//
//  Then.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import Foundation

protocol Then {}

extension Then where Self: AnyObject {
    
    @inlinable
    func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

extension NSObject: Then {}
