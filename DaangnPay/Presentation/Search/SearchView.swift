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
    }
    
    let emptyView = UIView()
    
    let emptyViewImage = UIImageView().then {
        $0.image = UIImage(named: "karrotIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    let emptyViewLabel = UILabel().then {
        $0.text = "도서를 검색해 보세요!"
        $0.textColor = .systemGray
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
        [bookListTableView, searchBar, emptyView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [emptyViewImage, emptyViewLabel].forEach {
            emptyView.addSubview($0)
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
        
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyViewImage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyViewImage.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
            emptyViewImage.widthAnchor.constraint(equalToConstant: 250),
            emptyViewImage.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            emptyViewLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyViewLabel.bottomAnchor.constraint(equalTo: emptyViewImage.topAnchor, constant: -16)
        ])
    
    }
}
