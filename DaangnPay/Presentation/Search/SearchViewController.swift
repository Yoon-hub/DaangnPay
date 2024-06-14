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
    
    private var diffableDataSource: UITableViewDiffableDataSource<Int, Book>!
    
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
        setDataSoucre()
    }
    
    override func handleOutput(_ state: SearchViewModel.State) {
        switch state {
        case .reloadTableView:
            self.updateSnapshot(with: viewModel.bookList)
        default:
            break
        }
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyWord = searchBar.text else {return}
        viewModel.input(.searchButtonTap(keyWord))
    }
}

// MARK: - TableView
extension SearchViewController {
    private func setDataSoucre() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: searchView.bookListTableView, cellProvider: { tableView, indexPath, book in
            print(book)
            let cell = tableView.dequeueReusableCell(withIdentifier: BookListTableViewCell.identifier, for: indexPath) as! BookListTableViewCell
            
            cell.bind(book: book)
            
            return cell
        })
    }
    
    
    private func updateSnapshot(with items: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}
