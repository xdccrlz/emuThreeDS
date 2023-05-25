//
//  LibraryManager.swift
//  emuThreeDS
//
//  Created by Antique on 25/5/2023.
//

import Accelerate
import Foundation
import UIKit


struct Rom : Codable, Hashable {
    let publisher: String
    let size: String
    let title: String
    
    let path: String
}

class LibraryManager {
    static let shared = LibraryManager()
    
    func getLibrary() -> [Rom]? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let romsDirectory = documentsDirectory.appendingPathComponent("roms", conformingTo: .directory)
        if !FileManager.default.fileExists(atPath: romsDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: romsDirectory, withIntermediateDirectories: false)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        let wrapper = CitraWrapper.sharedInstance()
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: romsDirectory.path).filter { $0.hasSuffix(".3ds") || $0.hasSuffix(".cci") || $0.hasSuffix(".cia") }
            if contents.count == 0 {
                return nil
            }
            
            return contents.reduce(into: [Rom]()) { partialResult, romFile in
                let romPath = romsDirectory.appendingPathComponent(romFile, conformingTo: .fileURL)
                
                let byteCountFormatter = ByteCountFormatStyle(style: .file, allowedUnits: [.mb, .gb])
                var fileSize: Int64 = 0
                do {
                    fileSize = try FileManager.default.attributesOfItem(atPath: romPath.path)[.size] as? Int64 ?? 0
                } catch {
                    print(error.localizedDescription)
                }
                
                
                let publisher = wrapper.getPublisher(romPath.path)
                let title = wrapper.getTitle(romPath.path).replacingOccurrences(of: "\n", with: " ") // some games have newlines...
                
                partialResult.append(Rom(publisher: publisher, size: byteCountFormatter.format(fileSize), title: title, path: romPath.path))
                partialResult.sort(by: { $0.title < $1.title })
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
