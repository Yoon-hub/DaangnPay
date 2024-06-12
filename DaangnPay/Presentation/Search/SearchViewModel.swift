//
//  SearchViewModel.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import Foundation
import Combine

final class SearchViewModel: ViewModelable {
    
    enum Action {
        
    }
    
    enum State {
        
    }
    
    var output: AnyPublisher<State, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    private var outputSubject = PassthroughSubject<State, Never>()
    
    func input(_ action: Action) {
        
    }
    
}