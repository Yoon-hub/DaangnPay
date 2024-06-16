//
//  DetailViewModel.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/15/24.
//

import Foundation
import Combine
import PDFKit

final class DetailViewModel: ViewModelable {
    
    enum Action {
        case viewDidAppear
    }
    
    enum State {
        case setPDFDocument(PDFDocument)
        case stopIndicator
    }
    
    var output: AnyPublisher<State, Never> {
        outputSubject.eraseToAnyPublisher()
    }
    
    private var outputSubject = PassthroughSubject<State, Never>()
    
    struct Dependency {
        let detailBookData: DetailResponseDTO
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    let dependency: Dependency
    
    func input(_ action: Action) {
        switch action {
        case .viewDidAppear:
            if let pdf = dependency.detailBookData.pdf {
                guard let pdfDocument = makePDFDocument(url: pdf) else {return}
                outputSubject.send(.setPDFDocument(pdfDocument))
            }
            outputSubject.send(.stopIndicator)
        }
    }
}

// MARK: -
extension DetailViewModel {
    private func makePDFDocument(url: [String: String]) -> PDFDocument? {
        
        var documents: [PDFDocument] = []
        
        for (index, (key, value)) in url.enumerated() {
            guard let pdfURL = URL(string: value) else { return nil }
            guard let document = PDFDocument(url: pdfURL) else { return nil }
            documents.append(document)
        }
        
        let document = PDFDocument()
        
        for i in documents {
            for j in 0...i.pageCount {
                if let page: PDFPage = i.page(at: j) {
                    document.insert(page, at: document.pageCount)
                }
            }
        }
        
        return document
    }
}
