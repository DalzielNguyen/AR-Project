//
//  BodyError.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/3/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation

enum BodyError {
    case jsonData
    case urlData
    case encoding
    case notFault
    case get
}

extension BodyError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .jsonData:
            return "Can not init data with json input."
        case .urlData:
            return "Data in dictionary is wrong type."
        case .encoding:
            return "Can not encoding url Data."
        case .notFault:
            return "Body is not fault."
        case .get:
            return "Get method have body."
            //            default:
            //            fatalError("fall through")
        }
    }
}
