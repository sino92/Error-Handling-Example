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
        let triggerPressHere: AnyObserver<Void>
    }

    struct Output {
        let userAge: Driver<String>
        let userName: Driver<String>
    }

    init() {
        let request = FirebaseClientAPI(request: .database)

        let userObserver = request
            .submitRequest()
            .map { User.init(json: $0) }

        let triggeredUserData = triggerPressHereSubject
            .flatMapLatest { userObserver }

        let userName = triggeredUserData.map { $0?._name ?? "" }
        let userAge = triggeredUserData.map { "\($0?._age ?? 0)"  }

        input = Input(triggerPressHere: triggerPressHereSubject.asObserver())
        output = Output(
            userAge: userAge.asDriver(onErrorJustReturn: ""),
            userName: userName.asDriver(onErrorJustReturn: "")
        )
    }
}
