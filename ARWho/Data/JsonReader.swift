//
//  JsonReader.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/12/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation

class JsonReader {
    private let json: [String: Any]
    init(_ json: [String: Any]) {
        self.json = json
    }
    
    init(json: Data) throws {
        if let values = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] {
            self.json = values
        } else {
            throw JsonReaderError.initJson
        }
    }
    
    func readString(_ name: String) -> String {
        let value = json[name]
        if value == nil {
            return ""
        } else if let convertValues = value as? String {
            return convertValues
        } else if let convertValues = value as? Int {
            return String(convertValues)
        } else if let convertValues = value as? Double {
            return String(convertValues)
        } else {
            return ""
        }
    }
    
    func readInt(_ name: String) -> Int {
        let value = json[name]
        if value == nil {
            return 0
        } else if let convertValues = value as? Int {
            return convertValues
        } else if let convertValues = value as? String {
            return Int(convertValues) ?? 0
        } else if let convertValues = value as? Double {
            return Int(convertValues)
        } else {
            return 0
        }
    }
    
    func readDouble(_ name: String) -> Double {
        let value = json[name]
        if value == nil {
            return 0
        } else if let convertValues = value as? Double {
            return convertValues
        } else if let convertValues = value as? String {
            return Double(convertValues) ?? 0
        } else if let convertValues = value as? Int {
            return Double(convertValues)
        } else {
            return 0
        }
    }
    
    func readBool(_ name: String) -> Bool {
        let value = json[name]
        return (value as? Bool) ?? false
    }
    
    func readObject<T>(_ name: String, _ parser: JsonParser<T>) -> T? {
        let value = json[name]
        if let convertValue = value as? [String: Any] {
            let convert = JsonReader(convertValue)
            return parser(convert)
        } else {
            return nil
        }
    }
    
    func readRequiredObject<T>(_ name: String, _ parser: JsonParser<T>) throws -> T {
        let value = json[name]
        if value == nil {
            throw JsonReaderError.fieldIsRequired(fieldName: name)
        } else if let convertValue = value as? [String: Any] {
            let convert = JsonReader(convertValue)
            return parser(convert)
        } else {
            throw JsonReaderError.fieldIsRequired(fieldName: name)
        }
    }
    
    func readList<T>(_ name: String, _ parser: JsonParser<T>) -> [T] {
        let listValues = json[name]
        if listValues == nil {
            return []
        } else if let convertValues = listValues as? [Any] {
            var listValues = [T]()
            for value in convertValues {
                if let convertValue = value as? [String: Any] {
                    let convert = JsonReader(convertValue)
                    listValues.append(parser(convert))
                }
            }
            return listValues
        } else {
            return []
        }
    }
}
