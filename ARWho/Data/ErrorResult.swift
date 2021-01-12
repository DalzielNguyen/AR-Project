//
//  ErrorResult.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/1/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation
struct ErrorResult {
    let error: String
    let error_description: String

    static let parser: JsonParser<ErrorResult> = { reader in
        ErrorResult(
            error: reader.readString("error"),
            error_description: reader.readString("error_description")
        )
    }
}

extension ErrorResult: CustomStringConvertible {
    var description: String {
        "\(error_description)"
    }
}
