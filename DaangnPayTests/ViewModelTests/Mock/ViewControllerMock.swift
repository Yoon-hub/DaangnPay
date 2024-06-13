//
//  ViewControllerMock.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/13/24.
//

import UIKit
import Combine
@testable import DaangnPay

final class ViewControllerMock<T: ViewModelable>: Presentable {
    
    typealias ViewModelType = T
    
    var viewModel: ViewModelType
    
    var statePublisher: AnyPublisher<ViewModelType.State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private let stateSubject = PassthroughSubject<ViewModelType.State, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        viewModel.output
            .sink { [weak self] state in self?.stateSubject.send(state) }
            .store(in: &cancellables)
    }
}
