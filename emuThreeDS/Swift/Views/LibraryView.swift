//
//  RomsView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var globalManager: GlobalManager
    
    var body: some View {
        NavigationView {
            if let library = globalManager.libraryManager.getLibrary() {
                List(globalManager.libraryManager.initials(from: library), id: \.character) { initial in
                    Section(initial.character) {
                        ForEach(globalManager.libraryManager.roms(for: initial, using: library), id: \.title) { rom in
                            RomView(rom: rom, wrapper: globalManager.libraryManager.wrapper)
                                .onTapGesture {
                                    globalManager.emulationManager.load(rom: rom)
                                }
                        }
                    }
                    .headerProminence(.increased)
                }
                .navigationTitle("Library")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { } label: {
                            Label("Install CIA", systemImage: "plus")
                        }
                    }
                }
            } else {
                Text("No Roms")
                    .foregroundColor(.secondary)
                .navigationTitle("Library")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button { } label: {
                            Label("Install CIA", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
}
