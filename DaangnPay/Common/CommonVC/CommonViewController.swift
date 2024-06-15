//
//  CommonViewController.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/11/24.
//

import UIKit
import Combine

class CommonViewController<ViewModel: ViewModelable>: UIViewController, Presentable {
    
    typealias ViewModelType = ViewModel
    
    let viewModel: ViewModelType
    
    var statePublisher: AnyPublisher<ViewModel.State, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    private var stateSubject = PassthroughSubject<ViewModel.State, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        set()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleOutput(_ state: ViewModelType.State) { }
    
    // MARK: - Set
    func set() {
        setUI()
        viewModelOutPutbind()
        setNavigationBar()
    }
    
    func setUI() {view.backgroundColor = .white}
    func setNavigationBar() {}
    
    // MARK: - ViewModel Interaction
    private func viewModelOutPutbind() {
        viewModel.output
            .sink { [weak self] state in self?.stateSubject.send(state) }
            .store(in: &cancellables)
        
        stateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleOutput(state)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Alert
extension CommonViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
