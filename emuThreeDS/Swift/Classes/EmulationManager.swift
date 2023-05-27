//
//  EmulationManager.swift
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

import Foundation
import MetalKit

class EmulationManager {
    static let shared = EmulationManager()
    private let wrapper = CitraWrapper()
    
    var hasConfigured: Bool = false
    
    func use(layer: CAMetalLayer) {
        wrapper.use(layer)
    }
    
    func load(rom: Rom) {
        wrapper.load(rom.path)
    }
    
    func pause() {
        wrapper.pause()
    }
    
    func run() {
        hasConfigured = true
        wrapper.run()
    }
    
    
    func touchesBegan(at location: CGPoint) {
        wrapper.touchesBegan(location)
    }
    
    func touchesMoved(at location: CGPoint) {
        wrapper.touchesMoved(location)
    }
    
    func touchesEnded() {
        wrapper.touchesEnded()
    }
}
