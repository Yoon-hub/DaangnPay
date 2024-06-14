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
    
    func test_searchButtonTap_returnsExpectedBookList() async {
        
        let expectation = self.expectation(description: "Search completes")
        
        // 이벤트 방출 이전에 구독
        viewController.statePublisher
            .sink { state in
                // it: ViewContoller output으로 tableViewReload 전달
                XCTAssertEqual(state, SearchViewModel.State.reloadTableView)
                expectation.fulfill()
            }
            .store(in: &viewController.cancellables)
        
        // context: TDD 입력이 발생하면
        searchViewModel.input(.searchButtonTap("TDD"))
         
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // it: bookList에 정상적으로 저장
        XCTAssertEqual(searchViewModel.bookList.first?.title, "Learning Swift 2 Programming, 2nd Edition")
        XCTAssertEqual(searchViewModel.currentPage, 1)
    }

    
    func test_searchButtonTap_returnsExpectedError() async {
        
        // describe: SearchViewModel에서 실패하는 APIService를 주입받았을 때
        let dependency = SearchViewModel.Dependency(apiService: APIServiceStub(error: ErrorMock.error, data: nil))
        
        searchViewModel = SearchViewModel(dependency: dependency)
        viewController = ViewControllerMock(viewModel: searchViewModel)
        
        let expectation = self.expectation(description: "Search completes")
        
        viewController.statePublisher
            .sink { state in
                // it: ViewController에 error Alert 전달
                XCTAssertEqual(state, SearchViewModel.State.showErrorAlert(ErrorMock.error))
                expectation.fulfill()
            }
            .store(in: &viewController.cancellables)
        
        // context: TDD 입력이 발생하면
        searchViewModel.input(.searchButtonTap("TDD"))
    
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_scrollDidBottom_returnsNextPage() async {
        
        let expectation = self.expectation(description: "Search completes")
        
        // 이벤트 방출 이전에 구독
        viewController.statePublisher
            .sink { state in
                // it: ViewContoller output으로 tableViewReload 전달
                XCTAssertEqual(state, SearchViewModel.State.reloadTableView)
                expectation.fulfill()
            }
            .store(in: &viewController.cancellables)
        
        searchViewModel.totalPage = 10
        searchViewModel.currentPage = 1
        
        // context: 아래로 스크롤 되면
        searchViewModel.input(.scrollDidBottom)
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // it: bookList에 정상적으로 추가 되고, currentPage 증가
        XCTAssertEqual(searchViewModel.bookList.first?.title, "Learning Swift 2 Programming, 2nd Edition")
        XCTAssertEqual(searchViewModel.currentPage, 2)
    }
    
}
