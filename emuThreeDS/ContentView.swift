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
            RomsView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Roms")
                }
            
            EmulationView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Emulation")
                }
        }
    }
}
