//
//  GlobalManager.swift
//  emuThreeDS
//
//  Created by Antique on 30/5/2023.
//

import SwiftUI

class GlobalManager: ObservableObject {
    static let shared = GlobalManager()
    
    @Published var citraWrapper = CitraWrapper.sharedInstance()
    @Published var emulationManager = EmulationManager.shared
    @Published var libraryManager = LibraryManager.shared
}
