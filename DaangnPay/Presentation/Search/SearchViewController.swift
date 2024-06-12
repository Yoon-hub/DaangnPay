//
//  SearchViewController.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import UIKit
import Combine

final class SearchViewController: CommonViewController<SearchViewModel> {
    
    let searchView: SearchView
    
    init(searchView: SearchView, viewMdoel: ViewModelType) {
        self.searchView = searchView
        super.init(viewModel: viewMdoel)
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        self.view = searchView
    }
    
    override func set() {
        super.set()
        searchView.searchBar.delegate = self
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyWord = searchBar.text else {return}
        viewModel.input(.searchButtonTap(keyWord))
    }
}

