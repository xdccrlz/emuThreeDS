//
//  emuThreeDSApp.swift
//  emuThreeDS
//
//  Created by Antique on 22/5/2023.
//

import SwiftUI

@main
struct emuThreeDSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // UserDefaults.standard.removeObject(forKey: "configuredSettings")
                    if !UserDefaults.standard.bool(forKey: "configuredSettings-1064") {
                        // Core
                        UserDefaults.standard.set(false, forKey: "use_cpu_jit")
                        UserDefaults.standard.set(true, forKey: "use_hle")
                        UserDefaults.standard.set(100, forKey: "cpu_clock_percentage")
                        UserDefaults.standard.set(true, forKey: "is_new_3ds")
                        UserDefaults.standard.setValue(true, forKey: "enable_logging")
                        
                        // Renderer
                        UserDefaults.standard.set(false, forKey: "async_shader_compilation")
                        UserDefaults.standard.set(true, forKey: "async_presentation")
                        UserDefaults.standard.set(true, forKey: "use_hw_shader")
                        UserDefaults.standard.setValue(true, forKey: "use_vsync_new")
                        UserDefaults.standard.setValue(true, forKey: "shaders_accurate_mul")
                        UserDefaults.standard.setValue(true, forKey: "use_shader_jit")
                        UserDefaults.standard.set(2, forKey: "resolution_factor")
                        UserDefaults.standard.set(5, forKey: "portrait_layout_option")
                        UserDefaults.standard.set(6, forKey: "landscape_layout_option")
                        
                        UserDefaults.standard.set(false, forKey: "swap_screen")
                        UserDefaults.standard.set(false, forKey: "upright_screen")
                        
                        UserDefaults.standard.setValue(0, forKey: "render_3d")
                        UserDefaults.standard.setValue(0, forKey: "factor_3d")
                        UserDefaults.standard.setValue(false, forKey: "dump_textures")
                        UserDefaults.standard.setValue(false, forKey: "custom_textures")
                        UserDefaults.standard.setValue(false, forKey: "async_custom_loading")
                        
                        UserDefaults.standard.set(true, forKey: "configuredSettings-1064")
                    }
                }
                .tint(.yellow)
        }
    }
}
