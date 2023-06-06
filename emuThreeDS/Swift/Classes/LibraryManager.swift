//
//  LibraryManager.swift
//  emuThreeDS
//
//  Created by Antique on 25/5/2023.
//

import Accelerate
import Foundation
import UIKit

class LibraryManager {
    static let shared = LibraryManager()
    let wrapper = CitraWrapper.sharedInstance()
    
    func getLibrary() -> [Initial : [Rom]]? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let directory = documentsDirectory.appendingPathComponent("roms", conformingTo: .directory)
        if !FileManager.default.fileExists(atPath: directory.path) {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: directory.path).filter { $0.hasSuffix(".3ds") || $0.hasSuffix(".cci") || $0.hasSuffix(".cia") }
            if contents.count == 0 {
                return nil
            }
            
            return contents.reduce(into: [Initial : [Rom]]()) { partialResult, file in
                let path = directory.appendingPathComponent(file, conformingTo: .fileURL).path
                
                let byteCountFormatter = ByteCountFormatStyle(style: .file, allowedUnits: [.mb, .gb])
                var size = "0 MB"
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: path)
                    size = byteCountFormatter.format(attributes[.size] as? Int64 ?? 0)
                } catch {
                    print(error.localizedDescription)
                }
                
                
                let publisher = wrapper.getPublisher(path)
                let region = wrapper.getRegion(path)
                let title = wrapper.getTitle(path).replacingOccurrences(of: "\n", with: " ") // some games have newlines...
                
                let initial = Initial(character: String(title.first?.uppercased() ?? ""))
                let rom = Rom(publisher: publisher, regions: region, size: size, title: title, path: path)
                partialResult[initial] == nil ? partialResult[initial] = [rom] : partialResult[initial]!.append(rom)
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func initials(from library: [Initial : [Rom]]) -> [Initial] {
        return library.keys.reduce(into: [Initial](), { $0.append($1) }).sorted()
    }
    
    func roms(for initial: Initial, using library: [Initial : [Rom]]) -> [Rom] {
        return library[initial]!.reduce(into: [Rom](), { $0.append($1) }).sorted() // not recommended but checks exist
    }
}
