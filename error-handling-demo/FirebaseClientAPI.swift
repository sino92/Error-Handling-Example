//
//  FirebaseClientAPI.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import Foundation
import RxSwift

typealias JSON = [String: AnyObject]

final class FirebaseClientAPI {

    private let _request: Request

    init(request: Request) {
        _request = request
    }

    func submitRequest() -> Observable<Result<JSON>> {
        guard let request = _request.urlRequest else { return Observable.empty() }
        return Observable.create { obx in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                print("Request submitted")

                guard error == nil else {
                    return obx.onNext(.failure(.requestFailure(error!.localizedDescription)))
                }

                guard let anyJson = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments),
                    let json = anyJson as? [String:AnyObject]
                    else {
                        return obx.onNext(.failure(.parsingFailure))
                }
                obx.onNext(.success(json))
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
