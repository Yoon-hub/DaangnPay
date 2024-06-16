//
//  DetailViewController.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/15/24.
//

import UIKit

final class DetailViewController: CommonViewController<DetailViewModel> {
    let detailView: DetailView!
    
     init(detailView: DetailView, viewModel: ViewModelType) {
        self.detailView = detailView
        super.init(viewModel: viewModel)
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input(.viewDidAppear)
    }
    
    // MARK: Set
    override func set() {
        super.set()
        detailView.bind(detailResponse: viewModel.dependency.detailBookData)
    }
    
    override func setNavigationBar() {
        self.navigationItem.title = "상세 화면"
    }
    
    override func handleOutput(_ state: ViewModelType.State) {
        switch state {
        case .setPDFDocument(let pdfDocument):
            detailView.updateViewHeight()
            detailView.pdfView.document = pdfDocument
        }
    }
}
