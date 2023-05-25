//
//  ContentView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Library")
                }
            
            EmulationView()
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
