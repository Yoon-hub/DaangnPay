//
//  APIServiceStub.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/13/24.
//

import Foundation
@testable import DaangnPay

final class APIServiceStub: APIServiceProtocol {
    
    private let error: Error?
    private let data: Decodable?
    
    init(error: Error? = nil, data: Decodable? = nil) {
        self.error = error
        self.data = data
    }
    
    func apiRequest<T: Decodable, Router: RouterProtocol>(type: T.Type, router: Router) async throws -> T {
        
        if let error { throw error }
        
        guard let data = data as? T else {
            throw URLError(.badServerResponse)
        }
        
       return data
    }
}

enum ErrorMock: Error {
    case error
}
