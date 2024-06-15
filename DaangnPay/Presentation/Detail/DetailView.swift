//
//  DetailView.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/15/24.
//

import UIKit

final class DetailView: UIView {
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
    }
    
    let subtitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let authorsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let publisherLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let languageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let isbn10Label = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let isbn13Label = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let pagesLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let yearLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let ratingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let descLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let urlLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [bookImageView,titleLabel, subtitleLabel, authorsLabel, publisherLabel, languageLabel, isbn10Label, isbn13Label, pagesLabel, yearLabel, ratingLabel, descLabel, priceLabel, urlLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bookImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bookImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bookImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        var lastView: UIView = bookImageView
        
        [titleLabel, subtitleLabel, authorsLabel, publisherLabel, languageLabel, isbn10Label, isbn13Label, pagesLabel, yearLabel, ratingLabel, descLabel, priceLabel, urlLabel].forEach {
            
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                $0.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20)
            ])
            
            lastView = $0
        }
        
        lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    
    }
    
    func bind(detailResponse: DetailResponseDTO) {
        let labelsAndData: [(UILabel, String)] = [
            (titleLabel, detailResponse.title),
            (subtitleLabel, detailResponse.subtitle),
            (authorsLabel, detailResponse.authors),
            (publisherLabel, detailResponse.publisher),
            (languageLabel, detailResponse.language),
            (isbn10Label, detailResponse.isbn10),
            (isbn13Label, detailResponse.isbn13),
            (pagesLabel, detailResponse.pages),
            (yearLabel, detailResponse.year),
            (ratingLabel, detailResponse.rating),
            (descLabel, detailResponse.desc),
            (priceLabel, detailResponse.price),
            (urlLabel, detailResponse.url)
        ]

        labelsAndData.forEach { label, data in
            label.text = data
        }
        
        guard let url = URL(string: detailResponse.image) else {return}
         bookImageView.loadImage(url: url, imagePlaceHolder: UIImage(named: "imagePlaceholder"))
    }
    
}
