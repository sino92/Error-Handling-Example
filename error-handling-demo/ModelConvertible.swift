//
//  ModelConvertible.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import Foundation

protocol ModelConvertible {
    init?(json: JSON)
}

extension ModelConvertible {
    static func convertToModel<T: ModelConvertible>(json: JSON) -> Result<T> {
        guard let user = T(json: json) else { return .failure(.modelConversionFailure) }
        return .success(user)
    }
}
