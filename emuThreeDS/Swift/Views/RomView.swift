//
//  RomView.swift
//  emuThreeDS
//
//  Created by Antique on 27/5/2023.
//

import SwiftUI

struct RomView: View {
    var rom: Rom
    var wrapper: CitraWrapper
    
    var body: some View {
        HStack {
            Image(uiImage: rom.getIcon(using: wrapper)) // could be better
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
                Text(rom.regions)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
