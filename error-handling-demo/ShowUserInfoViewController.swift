//
//  ShowUserInfoViewController.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import UIKit
import RxSwift
import RxCocoa

final class ShowUserInfoViewController: UIViewController {

    @IBOutlet private weak var pressHereButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let showUserInfoViewModel = ShowUserInfoViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pressHereButton.rx.controlEvent(.touchUpInside)
            .delay(2.0, scheduler: MainScheduler.instance)
            .bind(to: showUserInfoViewModel.input.triggerPressHere)
            .disposed(by: disposeBag)

        showUserInfoViewModel.output.userAge
            .drive(ageLabel.rx.text)
            .disposed(by: disposeBag)

        showUserInfoViewModel.output.userName
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        showUserInfoViewModel.output.hideActivityIndicator
            .startWith(true)
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)

        showUserInfoViewModel.output.animateActivityIndicator
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        showUserInfoViewModel.output.isReset
            .observeOn(MainScheduler())
            .delay(4.0, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.nameLabel.text = User.empty._name
                self.ageLabel.text = String(describing: User.empty._age) 
            }).disposed(by: disposeBag)
        
        showUserInfoViewModel.output.error.asObservable()
            .filter { $0 != .none }
            .observeOn(MainScheduler())
            .subscribe(onNext: { self.showAlert(with: $0) })
            .disposed(by: disposeBag)
    }

    private func showAlert(with clientAPIError: CustomError) {
        let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: "Something went wrong", message: clientAPIError.localizedDescription, preferredStyle: .alert)
        alertViewController.addAction(okAlertAction)
        present(alertViewController, animated: true, completion: nil)
    }
}
