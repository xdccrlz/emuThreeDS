//
//  Rom.swift
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

import Foundation
import UIKit

struct Rom : Codable, Hashable, Comparable {
    let publisher: String
    let regions: String
    let size: String
    let title: String
    
    let path: String
    
    func getIcon(using wrapper: CitraWrapper) -> UIImage {
        return Data(bytes: wrapper.getIcon(path), count: 48 * 48 * 8).decodeRGB565(width: 48, height: 48) ?? UIImage(systemName: "photo.fill")!
    }
    
    static func < (lhs: Rom, rhs: Rom) -> Bool {
        return lhs.title < rhs.title
    }
}
