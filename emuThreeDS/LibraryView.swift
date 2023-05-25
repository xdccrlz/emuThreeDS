//
//  RomsView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct LibraryView: View {
    var libraryManager = LibraryManager()
    var wrapper = CitraWrapper()
    
    var body: some View {
        NavigationView {
            if let roms = libraryManager.getLibrary() {
                List {
                    ForEach(roms, id: \.title) { rom in
                        HStack {
                            Image(uiImage: Data(bytes: wrapper.getIcon(rom.path), count: 48 * 48 * 8).decodeRGB565(width: 48, height: 48) ?? UIImage()) // could be better
                                .resizable()
                                .cornerRadius(8)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text(rom.title)
                                    .lineLimit(1)
                                HStack {
                                    Text(rom.publisher)
                                        .lineLimit(1)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(rom.size)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(String(rom.path.suffix(3)).uppercased())
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }
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
