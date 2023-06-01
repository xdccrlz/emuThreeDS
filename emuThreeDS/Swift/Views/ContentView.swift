//
//  ContentView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var globalManager = GlobalManager.shared
    
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            LibraryView(selection: $selection)
                .environmentObject(globalManager)
                .tabItem {
                    Label("Library", systemImage: "folder")
                }
                .tag(0)
            EmulationView()
                .environmentObject(globalManager)
                .tabItem {
                    Label("Emulation", systemImage: "gamecontroller")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
    }
}
