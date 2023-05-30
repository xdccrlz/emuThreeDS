//
//  EmulationViewControllerRepresentable.swift
//  emuThreeDS
//
//  Created by Antique on 30/5/2023.
//

import SwiftUI

struct EmulationViewControllerRepresentable: UIViewControllerRepresentable {
    var emulationManager: EmulationManager
    
    func makeUIViewController(context: Context) -> some EmulationViewController {
        EmulationViewController(emulationManager: emulationManager)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
