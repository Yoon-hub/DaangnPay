//
//  SearchResponseDTO.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/12/24.
//

import Foundation

struct SearchResponseDTO: Decodable {
    let error: String
    let total: String
    let page: String
    let books: [Book]
}

struct Book: Decodable, Hashable {
    let title: String
    let subtitle: String?
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
