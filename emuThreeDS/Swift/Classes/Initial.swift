//
//  Initial.swift
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

import Foundation

struct Initial : Codable, Hashable, Comparable {
    let character: String
    
    static func < (lhs: Initial, rhs: Initial) -> Bool {
        return lhs.character < rhs.character
    }
}
