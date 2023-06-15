//
//  ImportedItem.swift
//  emuThreeDS
//
//  Created by Antique on 15/6/2023.
//

import Foundation

struct ImportedItem : Codable, Comparable, Hashable, Identifiable {
    var id = UUID()
    
    let publisher, region, size, title: String
    
    init(gameInfo: (String, String, String, String)) {
        self.publisher = gameInfo.0
        self.region = gameInfo.1
        self.size = gameInfo.2
        self.title = gameInfo.3
    }
    
    
    static func < (lhs: ImportedItem, rhs: ImportedItem) -> Bool {
        return lhs.title < rhs.title
    }
}
