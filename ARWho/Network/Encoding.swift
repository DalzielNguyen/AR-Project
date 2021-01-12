//
//  Encoding.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/3/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation
func encoding(_ dictionary: [String: Any?]) -> String {
    var convertString: String = ""
    for data in dictionary {
        if !convertString.isEmpty {
            convertString.append("&")
        }
        let convertKey = data.key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if convertKey == nil {
            fatalError("Convert Key is nil")
        } else {
            if data.value == nil {
                fatalError("Key is nil")
            } else {
                if data.value is Int {
                    convertString.append("\(convertKey!)=\(data.value!)")
                } else if data.value is Bool {
                    convertString.append("\(convertKey!)=\(data.value!)")
                } else if data.value is Double {
                    convertString.append("\(convertKey!)=\(data.value!)")
                } else if data.value is String {
                    let convertValue: String?
                    if let stringData = data.value as? String {
                        convertValue = stringData.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    } else {
                        fatalError("Can not parse data value")
                    }
                    if convertValue == nil {
                        fatalError("Convert value is nil")
                    } else {
                        convertString.append("\(convertKey!)=\(convertValue!)")
                    }
                } else {
                    fatalError("Type of Data is wrong format")
                }
            }
        }
    }
    return convertString
}
