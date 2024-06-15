//
//  DetailTesponseDTO.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/15/24.
//

import Foundation

struct DetailResponseDTO: Codable, Equatable {
    let error, title, subtitle, authors: String
    let publisher, language, isbn10, isbn13: String
    let pages, year, rating, desc: String
    let price: String
    let image: String
    let url: String
    let pdf: [String: String]?
}
