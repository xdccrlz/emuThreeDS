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
    var metalView = MTKView()
    
    var layer: CALayer? {
        return metalView.layer
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeUIView(context: Context) -> some UIView {
        metalView.isUserInteractionEnabled = true
        metalView.device = MTLCreateSystemDefaultDevice()
        return metalView
    }
}

struct EmulationView: View {
    @EnvironmentObject var globalManager: GlobalManager
    
    var metalView = MetalView()
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                metalView
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
                    .gesture( // TODO: dragging is prob WAY off course
                        DragGesture()
                            .onChanged { globalManager.emulationManager.touchesMoved(at: $0.location) }
                            .onEnded { _ in globalManager.emulationManager.touchesEnded() }
                    )
                    .onTapGesture { // TODO: tap is WAY off course
                        globalManager.emulationManager.touchesBegan(at: $0)
                        globalManager.emulationManager.touchesEnded()
                    }
                    .onAppear {
                        if !globalManager.emulationManager.hasConfigured {
                            globalManager.emulationManager.use(layer: metalView.layer as! CAMetalLayer)
                        }
                        
                        globalManager.emulationManager.run()
                    }
                    .onDisappear { globalManager.emulationManager.pause() }
            }
        }
    }
}
