//
//  ShowUserInfoViewModel.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol ShowUserInfoViewModelType {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

final class ShowUserInfoViewModel: ShowUserInfoViewModelType {

    let input: ShowUserInfoViewModel.Input
    let output: ShowUserInfoViewModel.Output

    var triggerPressHereSubject = PublishSubject<Void>()

    struct Input {
        // Observing any changes in button click events
        let triggerPressHere: AnyObserver<Void>
    }

    struct Output {
        
        // Displays user age upon user signal
        let userAge: Driver<String>
        
        // Displays user name upon user signal
        let userName: Driver<String>
        
        // Hides activity indicator before the network call and after object loading
        let hideActivityIndicator: Driver<Bool>
        
        // Animates the activity indicator in between the network call and object loading
        let animateActivityIndicator: Driver<Bool>
        
        // Displays error upon an error signal
        let error: Observable<CustomError>
        
        // Reset the output user information
        let isReset: Observable<Bool>
    }

    init() {
        let request = FirebaseClientAPI(request: .database)

        let userObservable = request
            .submitRequest()
            .map { User.decode(json: $0) }

        let triggeredUserData = triggerPressHereSubject
            .flatMapLatest { userObservable }
        
        let hasFetched = triggeredUserData.map { _ in true }
            .asDriver(onErrorJustReturn: true)

        let user = triggeredUserData.map { $0.value ?? .empty }
        let userName = user.map { $0._name }
        let userAge = user.map { "\($0._age)" }
        let error = triggeredUserData.map { $0.error ?? .none }
        
        let showSpinner = triggerPressHereSubject.map { _ in false }
            .asDriver(onErrorJustReturn: false)
        let isError = error
            .filter { $0 != .none }
            .map { _ in true }
            .asDriver(onErrorJustReturn: true)
        let hideActivityIndicator = Driver.of(hasFetched, isError, showSpinner)
            .merge()
        let animateActivityIndicator = hideActivityIndicator.map { !$0 }

        let resetSignal = user.map { _ in true }
        
        input = Input(triggerPressHere: triggerPressHereSubject.asObserver())
        output = Output(
            userAge: userAge.asDriver(onErrorJustReturn: ""),
            userName: userName.asDriver(onErrorJustReturn: ""),
            hideActivityIndicator: hideActivityIndicator,
            animateActivityIndicator: animateActivityIndicator,
            error: error,
            isReset: resetSignal
        )
    }
}
