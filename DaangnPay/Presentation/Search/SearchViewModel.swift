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
        case reloadTableView
        case showErrorAlert(Error)
    }
    
    var output: AnyPublisher<State, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    private var outputSubject = PassthroughSubject<State, Never>()
    
    struct Dependency {
        let apiService: APIServiceProtocol
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
    
    // MARK: - Properties
    let itmsPerPage = 10
    
    var bookList: [Book] = []
    var totalPage = 0
    var currentPage = 0
}

// MARK: - Network
extension SearchViewModel {
    
    func requestSearch(_ keyWord: String) {
        do {
            Task {
                let result = try await dependency.apiService.apiRequest(type: SearchResponseDTO.self, router: ItBookRouter.search(keyWord: keyWord))
                
                bookList = result.books
                totalPage = Int(ceil(Double(result.total)! / Double(itmsPerPage)))
                currentPage = 1
                outputSubject.send(.reloadTableView)
            }
        } catch {
            outputSubject.send(.showErrorAlert(error))
        }
    }
    
}
