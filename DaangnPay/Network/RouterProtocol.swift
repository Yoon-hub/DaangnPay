//
//  RouterProtocol.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/12/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol RouterProtocol {
    var baseURL: String { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var queryItems: [String: String]? { get }
}
