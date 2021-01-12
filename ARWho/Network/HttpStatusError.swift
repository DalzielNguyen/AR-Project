//
//  HttpStatusError.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/3/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation
class HttpStatusError {
    let content: Data
    let statusCode: Int
    init (_ content: Data, _ statusCode: Int){
        self.content = content
        self.statusCode = statusCode
    }
}
extension HttpStatusError: Error {
    
}
