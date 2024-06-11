//
//  Presentable.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import Foundation
import Combine

protocol Presentable {
    associatedtype ViewModelType: ViewModelable
    
    var viewModel: ViewModelType { get }
    var statePublisher: AnyPublisher<ViewModelType.State, Never> { get }
}
