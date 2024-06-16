//
//  ViewModelStateEquatable.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/14/24.
//

import Foundation
@testable import DaangnPay

extension SearchViewModel.State: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.reloadTableView, .reloadTableView):
            return true
        case (.showErrorAlert(let lhsError), .showErrorAlert(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.transitionToDetail(let lhsDetail), .transitionToDetail(let rhsDetail)):
            return lhsDetail == rhsDetail
        default:
            return false
        }
    }
}

extension DetailViewModel.State: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.setPDFDocument(let lhsPDFDocument), .setPDFDocument(let rhsPDFDocument)):
            return true
        default:
            return false
        }
    }
}

