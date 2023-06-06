//
//  emuThreeDSApp.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import AVFAudio
import SwiftUI

@main
struct emuThreeDSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // UserDefaults.standard.removeObject(forKey: "configuredSettings")
                    if !UserDefaults.standard.bool(forKey: "configuredSettings") {
                        // Core
                        UserDefaults.standard.set(false, forKey: "use_cpu_jit")
                        UserDefaults.standard.set(true, forKey: "use_hle")
                        UserDefaults.standard.set(100, forKey: "cpu_clock_percentage")
                        UserDefaults.standard.set(true, forKey: "is_new_3ds")
                        
                        // Renderer
                        UserDefaults.standard.set(5, forKey: "portrait_layout_option")
                        UserDefaults.standard.set(6, forKey: "landscape_layout_option")
                        UserDefaults.standard.set(2, forKey: "resolution_factor")
                        UserDefaults.standard.set(false, forKey: "async_shader_compilation")
                        UserDefaults.standard.set(true, forKey: "async_presentation")
                        UserDefaults.standard.set(true, forKey: "use_hw_shader")
                        
                        UserDefaults.standard.set(true, forKey: "configuredSettings")
                    }
                    
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch { print(error.localizedDescription, error) }
                }
                .tint(.yellow)
        }
    }
}
