//
//  ItBookRouter.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/12/24.
//

import Foundation

enum ItBookRouter: RouterProtocol {
    
    case search(keyWord: String)
    case searchWithPage(keyWord: String, page: String)
    
    var baseURL: String {
        "https://api.itbook.store/1.0/"
    }
    
    var endPoint: String {
        switch self {
        case .search(let keyWord):
            return "search/\(keyWord)"
        case .searchWithPage(keyWord: let keyWord, page: let page):
            return "search/\(keyWord)/\(page)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .search(_), .searchWithPage(_,_):
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .search(_), .searchWithPage(_,_):
            return nil
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .search(_), .searchWithPage(_,_):
            return nil
        }
    }
    
    var queryItems: [String : String]? {
        switch self {
        case .search(_), .searchWithPage(_,_):
            return nil
        }
    }
}
