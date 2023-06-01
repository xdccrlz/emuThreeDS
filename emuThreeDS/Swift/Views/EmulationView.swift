//
//  EmulationView.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

struct EmulationView: View {
    @EnvironmentObject var globalManager: GlobalManager
    
    var body: some View {
        EmulationViewControllerRepresentable(emulationManager: globalManager.emulationManager)
            .edgesIgnoringSafeArea(.all)
    }
}
