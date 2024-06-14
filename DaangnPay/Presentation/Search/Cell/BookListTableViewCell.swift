//
//  BookListTableViewCell.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/14/24.
//

import UIKit

final class BookListTableViewCell: UITableViewCell {
    
    let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    let subTitleLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = .systemFont(ofSize: 12)
    }
    
    let priceLabel = UILabel()
    
    let isbnLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 9)
    }
    
    let urlLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 9)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [bookImageView, titleLabel, subTitleLabel, priceLabel, isbnLabel, urlLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setUI() {
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookImageView.widthAnchor.constraint(equalToConstant: 100),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: bookImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: bookImageView.topAnchor, constant: 2),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            isbnLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            isbnLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            isbnLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            urlLabel.topAnchor.constraint(equalTo: isbnLabel.bottomAnchor, constant: 8),
            urlLabel.leadingAnchor.constraint(equalTo: isbnLabel.leadingAnchor),
            urlLabel.trailingAnchor.constraint(equalTo: isbnLabel.trailingAnchor),
            urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension BookListTableViewCell {
    func bind(book: Book) {
        
        guard let url = URL(string: book.image) else {return}
        bookImageView.loadImage(url: url)
        
        titleLabel.text = book.title
        subTitleLabel.text = book.subtitle
        priceLabel.text = book.price
        isbnLabel.text = book.isbn13
        urlLabel.text = book.url
    }
}
