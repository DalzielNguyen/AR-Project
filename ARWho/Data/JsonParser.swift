//
//  JsonParser.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/1/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation

typealias JsonParser<T> = (_ reader: JsonReader) -> T
