//
//  Scientist.swift
//  ScientistDectection
//
//  Created by Le-Sang Nguyen on 8/2/20.
//  Copyright © 2020 Le-Sang Nguyen. All rights reserved.
//

import Foundation

struct People : Decodable {
    let id: Int
    let name: String
    let dates: String
    let field: String
    let bio: String
    let country: String
    let source: String
    static let parser: JsonParser<People> = { reader in
        People(
            id: reader.readInt("id"),
            name: reader.readString("name"),
            dates: reader.readString("date"),
            field: reader.readString("field"),
            bio: reader.readString("bio"),
            country: reader.readString("country"),
            source: reader.readString("source")
        )
    }
}
