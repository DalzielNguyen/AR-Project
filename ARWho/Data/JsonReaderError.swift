//
//  JsonReaderErro.swift
//  ProjectTrainning
//
//  Created by Le-Sang Nguyen on 7/29/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//
import Foundation

enum JsonReaderError {
    case fieldIsRequired(fieldName: String)
    case convertData
    case inputFormat
    case inputData
    case initJson
    case url
    case session
    case listData
    case response
}

extension JsonReaderError: Error {
    
}

extension JsonReaderError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .fieldIsRequired(fieldName):
            return "The field \(fieldName) is required"
        case .convertData:
            return "Data can not convert to Json"
        case .initJson:
            return "Data can not init"
        case .inputData:
            return "InputData can be found"
        case .inputFormat:
            return "Wrong format of input"
        case .url:
            return "URL is indentified"
        case .session:
            return "Session can not call"
        case .listData:
            return "Can not convert list data"
        case .response:
            return "Error: not a valid http response"
            //        default:
            //            fatalError("fall through")
        }
    }
}
