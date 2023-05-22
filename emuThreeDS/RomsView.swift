//
//  RomsView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct RomsView: View {
    var body: some View {
        NavigationView {
            Text("No Roms")
                .foregroundColor(.secondary)
                .navigationTitle("Roms")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        // Opens a yet-to-be-made SettingsView so the user can customize settings.
                        Button { } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                        
                        // Opens a UIDocumentBrowserViewController so the user can select a .cia rom to install.
                        Button { } label: {
                            Label("Install CIA", systemImage: "plus.circle")
                        }
                    }
                }
        }
    }
}
