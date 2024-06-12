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
        case searchButtonTap(String)
    }
    
    enum State {
        
    }
    
    var output: AnyPublisher<State, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    private var outputSubject = PassthroughSubject<State, Never>()
    
    struct Dependency {
        let apiService: APIService
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    let dependency: Dependency
    
    func input(_ action: Action) {
        switch action {
        case .searchButtonTap(let keyWord):
            requestSearch(keyWord)
        }
    }
}

// MARK: - Network
extension SearchViewModel {
    
    func requestSearch(_ keyWord: String) {
        do {
            Task {
                let result = try await dependency.apiService.apiRequest(type: SearchResponseDTO.self, router: ItBookRouter.search(keyWord: keyWord))
            }
        } catch {
            print(error)
        }
    }
    
}
