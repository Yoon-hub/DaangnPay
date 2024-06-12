//
//  APIServiceTests.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/12/24.
//

import XCTest
@testable import DaangnPay

final class APIServiceTests: XCTestCase {
    var apiService: APIService!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        apiService = APIService()
        apiService.urlSession = URLSession(configuration: configuration)

    }
    
    override func tearDownWithError() throws {
        apiService = nil
    }
    
    func test_search_book_success() async throws {
        
        // Given
        let mockResponseData = """
        {
            "error": "0",
            "total": "1",
            "page": "1",
            "books": [
                {
                    "title": "Test Driven Development",
                    "subtitle": "By Example",
                    "isbn13": "9780321146533",
                    "price": "$44.95",
                    "image": "https://itbook.store/img/books/9780321146533.png",
                    "url": "https://itbook.store/books/9780321146533"
                }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockResponseData)
        }
        
        let router = ItBookRouter.search(keyWord: "TDD")
        
        do {
            
            // When
            let result: SearchResponseDTO = try await apiService.apiRequest(type: SearchResponseDTO.self, router: router)
            
            // Then
            XCTAssertEqual(result.books.first?.title, "Test Driven Development")
        } catch {
            XCTFail("네트워킹 성공을 기대 했지만 error 발생: \(error)")
        }
    }
    
    func test_search_book_fail() async throws {
        
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, Data())
        }
        
        let router = ItBookRouter.search(keyWord: "TDD")
        
        do {
            
            // When
            let _: SearchResponseDTO = try await apiService.apiRequest(type: SearchResponseDTO.self, router: router)
            XCTFail("네트워킹 실패를 기대했지만 성공 발생")
        } catch let error as DecodingError {
            
            // Then
            XCTAssertTrue(true, "기대했던 error 발생 \(error)")
        }
    }
}
