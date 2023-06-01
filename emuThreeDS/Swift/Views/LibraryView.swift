//
//  RomsView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var globalManager: GlobalManager
    
    @State var roms: [Initial : [Rom]] = [:]
    @Binding var selection: Int
    
    var body: some View {
        NavigationView {
            List(roms.keys.sorted(), id: \.character, rowContent: { initial in
                Section(initial.character) {
                    ForEach(globalManager.libraryManager.roms(for: initial, using: roms), id: \.title) { rom in
                        RomView(rom: rom, wrapper: globalManager.citraWrapper)
                            .onTapGesture {
                                globalManager.emulationManager.load(rom: rom)
                                selection = 1
                            }
                    }
                }
                .headerProminence(.increased)
            })
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .task {
                roms = globalManager.libraryManager.getLibrary() ?? [:]
            }
        }
    }
}
