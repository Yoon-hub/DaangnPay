//
//  DetailView.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/15/24.
//

import UIKit
import PDFKit

final class DetailView: UIView {
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .orange
        $0.hidesWhenStopped = true
    }
    
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
    
    let pdfView = PDFView().then {
        $0.backgroundColor = .yellow
        $0.autoScales = true
        $0.displayMode = .singlePageContinuous
        $0.displayDirection = .vertical
    }
    
    var pdfHeightConstraint: NSLayoutConstraint!
    
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
        

        indicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(indicator)
        
        [bookImageView,titleLabel, subtitleLabel, authorsLabel, publisherLabel, languageLabel, isbn10Label, isbn13Label, pagesLabel, yearLabel, ratingLabel, descLabel, priceLabel, urlLabel, pdfView].forEach {
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
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -30),
            indicator.widthAnchor.constraint(equalToConstant: 50),
            indicator.heightAnchor.constraint(equalToConstant: 50)
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
        
        pdfHeightConstraint = pdfView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pdfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            pdfView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20),
            pdfHeightConstraint
        ])
        
        pdfView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    
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
    
    func updateViewHeight() {
        pdfHeightConstraint.constant = 540
        self.layoutIfNeeded()
    }
    
}
