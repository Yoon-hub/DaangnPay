//
//  DetailViewModelTests.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/16/24.
//

import XCTest
import Combine
import PDFKit
@testable import DaangnPay

final class DetailViewModelTests: XCTestCase {
    var detailViewModel: DetailViewModel!
    var viewController: ViewControllerMock<DetailViewModel>!
    
    override func setUp() {
        let detailBookData = DetailResponseDTO(
            error: "0",
            title: "Securing DevOps",
            subtitle: "Security in the Cloud",
            authors: "Julien Vehent",
            publisher: "Manning",
            language: "English",
            isbn10: "1617294136",
            isbn13: "9781617294136",
            pages: "384",
            year: "2018",
            rating: "4",
            desc: "An application running in the cloud can benefit from incredible efficiencies, but they come with unique security threats too. A DevOps team's highest priority is understanding those risks and hardening the system against them. Securing DevOps teaches you the essential techniques to secure your c...",
            price: "$39.65",
            image: "https://itbook.store/img/books/9781617294136.png",
            url: "https://itbook.store/books/9781617294136",
            pdf: [
                "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
                "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
            ]
        )
        
        let dependency = DetailViewModel.Dependency(detailBookData: detailBookData)
        
        detailViewModel = DetailViewModel(dependency: dependency)
        viewController = ViewControllerMock(viewModel: detailViewModel)
    }
    
    override func tearDown() {
        detailViewModel = nil
        viewController = nil
    }
    
    func test_viewDidAppear_returnsExpectedPDFDocument() async {
        
        let expectation = self.expectation(description: "ViewDidAppear completes")
        
        // 이벤트 방출 이전에 구독
        viewController.statePublisher
            .first()
            .sink { state in
                // it: ViewContoller output으로 setPDFDocument 전달
                XCTAssertEqual(state, DetailViewModel.State.setPDFDocument(PDFDocument()))
                expectation.fulfill()
            }
            .store(in: &viewController.cancellables)
            
        // context: TDD 입력이 발생하면
        detailViewModel.input(.viewDidAppear)
         
        await fulfillment(of: [expectation], timeout: 1.0)
        

    }
}
