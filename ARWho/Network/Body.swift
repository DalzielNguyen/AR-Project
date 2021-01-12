//
//  Body.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/3/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation
import UIKit
protocol Body {
    var contentType: String { get }
    var data: Data { get }
}

class JsonBody: Body {
    var contentType: String { "application/json" }
    var data: Data
    init(_ json: [String: Any]) {
        if let value = try? JSONSerialization.data(withJSONObject: json, options: []) as Data {
            data = value
        } else {
            fatalError("Value input is not Json")
        }
    }
}

class UrlEncodedBody: Body {
    var contentType: String { "application/x-www-form-urlencoded" }
    var data: Data
    init(_ urlDictionary: [String: Any?]) {
        let convertString = encoding(urlDictionary)
        self.data = Data(convertString.utf8)
    }
}

