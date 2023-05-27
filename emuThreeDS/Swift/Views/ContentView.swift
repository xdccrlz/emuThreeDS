//
//  ContentView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import MetalKit
import SwiftUI

class GlobalManager: ObservableObject {
    @Published var emulationManager = EmulationManager.shared
    @Published var libraryManager = LibraryManager.shared
}

struct ContentView: View {
    @StateObject var globalManager = GlobalManager()
    
    var body: some View {
        TabView {
            LibraryView()
                .environmentObject(globalManager)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Library")
                }
            
            EmulationView()
                .environmentObject(globalManager)
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Emulation")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}
