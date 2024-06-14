//
//  SearchView.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import UIKit

final class SearchView: UIView {
    
    let searchBar = UISearchBar()
    
    let bookListTableView = UITableView().then {
        $0.rowHeight = 160
        $0.register(BookListTableViewCell.self, forCellReuseIdentifier: BookListTableViewCell.identifier)
        $0.backgroundColor = .systemGray5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setLayout()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [bookListTableView, searchBar].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        
        }
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    
        
        NSLayoutConstraint.activate([
            bookListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            bookListTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bookListTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bookListTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
