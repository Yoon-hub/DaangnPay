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
        case scrollDidBottom
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
            searchKeyword = keyWord
            isPageLoading = false
            requestSearch(keyWord)
        case .scrollDidBottom:
            if totalPage > currentPage { requestNextPage() }
        }
    }
    
    // MARK: - Properties
    private let itmsPerPage = 10
    
    var bookList: [Book] = []
    var totalPage = 0
    var currentPage = 0
    var searchKeyword = ""
    
    var isPageLoading = false
}

// MARK: - Network
extension SearchViewModel {
    
    private func requestSearch(_ keyWord: String) {
        Task {
            do {
                let result = try await dependency.apiService.apiRequest(type: SearchResponseDTO.self, router: ItBookRouter.search(keyWord: keyWord))
                
                bookList = result.books
                totalPage = Int(ceil(Double(result.total)! / Double(itmsPerPage)))
                currentPage = 1
                outputSubject.send(.reloadTableView)
            } catch {
                outputSubject.send(.showErrorAlert(error))
            }
        }
    }
    
    private func requestNextPage() {
        Task {
            do {
                let result = try await dependency.apiService.apiRequest(type: SearchResponseDTO.self, router: ItBookRouter.searchWithPage(keyWord: searchKeyword, page: String(currentPage + 1)))
                
                bookList.append(contentsOf: result.books)
                currentPage += 1
                isPageLoading = false
                outputSubject.send(.reloadTableView)
            } catch {
                isPageLoading = false
                outputSubject.send(.showErrorAlert(error))
            }
            
        }
    }
}
