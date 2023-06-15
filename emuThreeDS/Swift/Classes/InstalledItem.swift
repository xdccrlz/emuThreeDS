//
//  InstalledItem.swift
//  emuThreeDS
//
//  Created by Antique on 15/6/2023.
//

import Foundation

struct InstalledItem : Codable, Comparable, Hashable, Identifiable {
    var id = UUID()
    
    let publisher, region, size, title: String
    
    static func < (lhs: InstalledItem, rhs: InstalledItem) -> Bool {
        return lhs.title < rhs.title
    }
}
