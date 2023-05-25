//
//  EmulationView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import MetalKit
import SwiftUI

// may or may not work
struct MetalView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeUIView(context: Context) -> some UIView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        return metalView
    }
}

struct EmulationView: View {
    var body: some View {
        Text("No Emulation")
            .foregroundColor(.secondary)
        .navigationTitle("Emulation")
    }
}
