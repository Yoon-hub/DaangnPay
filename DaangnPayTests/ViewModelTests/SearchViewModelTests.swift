//
//  SearchViewModelTests.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/13/24.
//

import XCTest
import Combine
@testable import DaangnPay

final class SearchViewModelTests: XCTestCase {
    var searchViewModel: SearchViewModel!
    var viewController: ViewControllerMock<SearchViewModel>!
    
    override func setUp() {
        let books = [
            Book(title: "Learning Swift 2 Programming, 2nd Edition",
                 subtitle: "",
                 isbn13: "9780134431598",
                 price: "$28.32",
                 image: "https://itbook.store/img/books/9780134431598.png",
                 url: "https://itbook.store/books/9780134431598"),
            Book(title: "Learning Swift 3 Programming, 3nd Edition",
                 subtitle: "",
                 isbn13: "9780134431599",
                 price: "$29.32",
                 image: "https://itbook.store/img/books/9780134431599.png",
                 url: "https://itbook.store/books/9780134431599")]
        
        let searchResponseDTO = SearchResponseDTO(error: "0", total: "100", page: "1", books: books)
        let dependency = SearchViewModel.Dependency(apiService: APIServiceStub(error: nil, data: searchResponseDTO))
        
        searchViewModel = SearchViewModel(dependency: dependency)
        viewController = ViewControllerMock(viewModel: searchViewModel)
    }
    
    override func tearDown() {
        searchViewModel = nil
        viewController = nil
    }
    
    func test_searchButtonTap_returnsExpectedBookList() {
        
        // context: TDD 입력이 발생하면
        searchViewModel.input(.searchButtonTap("TDD"))
        
        // it: bookList에 정상적으로 저장
        XCTAssertEqual(searchViewModel.bookList.first?.title, "Learning Swift 2 Programming, 2nd Edition")
        XCTAssertEqual(searchViewModel.currentPage, 1)
        
        // it: ViewContoller에 reload output 전달
        viewController.statePublisher
            .sink { state in
                XCTAssertEqual(state, SearchViewModel.State.reloadTableView)
            }
            .store(in: &viewController.cancellables)
    }

    
    func test_searchButtonTap_returnsExpectedError() {
        
        // describe: SearchViewModel에서 실패하는 APIService를 주입받았을 때
        let dependency = SearchViewModel.Dependency(apiService: APIServiceStub(error: ErrorMock.error, data: nil))
        
        searchViewModel = SearchViewModel(dependency: dependency)
        viewController = ViewControllerMock(viewModel: searchViewModel)
        
        // context: TDD 입력이 발생하면
        searchViewModel.input(.searchButtonTap("TDD"))
        
        // it: ViewController에 error output 전달
        viewController.statePublisher
            .sink { state in
                XCTAssertEqual(state, SearchViewModel.State.showErrorAlert(ErrorMock.error))
            }
            .store(in: &viewController.cancellables)
    }
}
