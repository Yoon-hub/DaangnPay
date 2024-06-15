//
//  DetailViewModel.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/15/24.
//

import Foundation
import Combine

final class DetailViewModel: ViewModelable {
    
    enum Action {
    }
    
    enum State {
    }
    
    var output: AnyPublisher<State, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    private var outputSubject = PassthroughSubject<State, Never>()
    
    struct Dependency {
        let detailBookData: DetailResponseDTO
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    let dependency: Dependency
    
    func input(_ action: Action) {
        
    }

}
