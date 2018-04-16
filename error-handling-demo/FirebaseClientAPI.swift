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

    func submitRequest() -> Observable<JSON> {
        guard let request = _request.urlRequest else { return Observable.empty() }
        return Observable.create { obs in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { return }

                guard let anyJson = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments),
                    let json = anyJson as? [String:AnyObject]
                    else { return }
                obs.onNext(json)
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
