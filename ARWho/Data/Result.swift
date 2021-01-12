//
//  Result.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/3/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation
enum Result<T> {
    case success(_ value: T)
    case failure(_ error: Error)
}
