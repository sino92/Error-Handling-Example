//
//  CustomError.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import Foundation

enum CustomError: Error {
    case requestFailure(String)
    case parsingFailure
    case none
}

extension CustomError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .requestFailure(let description): return description
        case .parsingFailure: return "Parsing failure."
        default: return "None"
        }
    }
}

extension CustomError {
    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
        switch (lhs, rhs) {
        case (.parsingFailure, .none),
             (.requestFailure, .none): return false
        default: return true
        }
    }

    static func != (lhs: CustomError, rhs: CustomError) -> Bool {
        return !(lhs == rhs)
    }
}
