//
//  Data.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/1/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation
struct ListRequest {
    let people: [People]
    
    static let parser: JsonParser<ListRequest> = { reader in
        ListRequest(people: reader.readList("data", People.parser))
    }
}
