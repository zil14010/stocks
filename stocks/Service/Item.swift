//
//  Item.swift
//  stocks
//
//  Created by zipeng lin on 4/28/22.
//  Copyright © 2022 dk. All rights reserved.
//

import Foundation

struct Item: Codable {

    var symbol: String?
    var quote: MyQuote?

}

extension Item: Equatable {

    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.symbol == rhs.symbol
    }

}
