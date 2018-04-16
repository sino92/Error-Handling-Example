//
//  User.swift
//  error-handling-demo
//
//  Created by Sinan Eren on 4/16/18.
//

import Foundation

struct User: ModelConvertible {

    let _name: String
    let _age: Int

    init?(json: JSON) {
        guard let name = json["name"] as? String,
            let age = json["age"] as? Int else { return nil }
        _name = name
        _age = age
    }

    private init(name: String, age: Int) {
        _name = name
        _age = age
    }
    static let empty = User(name: "Empty", age: 0)

    static func decode(json: Result<JSON>) -> Result<User> {
        return json.flatMap(convertToModel)
    }
}
