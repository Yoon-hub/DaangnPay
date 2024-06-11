//
//  ViewModelable.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import Foundation
import Combine

protocol ViewModelable {
    associatedtype Action
    associatedtype State
    
    var output: AnyPublisher<State, Never> { get }
    func input(_ action: Action) 
}
