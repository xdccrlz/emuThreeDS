//
//  SettingsView.swift
//  emuThreeDS
//
//  Created by Antique on 25/5/2023.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            List(content: {
                Section {
                    ToggleSettingView(identifier: "use_cpu_jit", systemName: "cpu", title: "Enable JIT")
                    ToggleSettingView(identifier: "use_hle", systemName: "brain", title: "Enable HLE")
                    StepperSettingView(impactGenerator: impactGenerator, identifier: "cpu_clock_percentage", systemName: "percent", title: "CPU Clock", minValue: 5, maxValue: 400)
                    ToggleSettingView(identifier: "is_new_3ds", systemName: "star", title: "Use New 3DS")
                    ToggleSettingView(identifier: "enable_logging", systemName: "ladybug", title: "Enable Logging")
                } header: {
                    Text("Core")
                }
                .headerProminence(.increased)
                
                Section {
                    ToggleSettingView(identifier: "async_shader_compilation", systemName: "square.stack.3d.down.forward", title: "Async Shader Compilation")
                    ToggleSettingView(identifier: "async_presentation", systemName: "videoprojector", title: "Async Presentation")
                    ToggleSettingView(identifier: "use_hw_shader", systemName: "square.stack.3d.down.forward", title: "Enable HW Shaders")
                    ToggleSettingView(identifier: "use_vsync_new", systemName: "clock.arrow.2.circlepath", title: "Enable VSync New", isExperimental: true)
                    ToggleSettingView(identifier: "shaders_accurate_mul", systemName: "target", title: "Shaders Accurate Mul", isExperimental: true)
                    ToggleSettingView(identifier: "use_shader_jit", systemName: "bolt.badge.clock", title: "Enable Shader JIT", isExperimental: true)
                    ResolutionFactorSettingView(impactGenerator: impactGenerator, identifier: "resolution_factor", systemName: "aspectratio", title: "Resolution")
                    LayoutOptionSettingView(impactGenerator: impactGenerator, identifier: "portrait_layout_option", systemName: "iphone", title: "Portrait Layout")
                    LayoutOptionSettingView(impactGenerator: impactGenerator, identifier: "landscape_layout_option", systemName: "iphone.landscape", title: "Landscape Layout")
                } header: {
                    Text("Renderer")
                }
                .headerProminence(.increased)
                
                Section {
                    ToggleSettingView(identifier: "swap_screen", systemName: "rectangle.2.swap", title: "Swap Screen", isExperimental: true)
                    ToggleSettingView(identifier: "upright_screen", systemName: "leaf", title: "Upright Screen", isExperimental: true)
                    StereoRenderSettingView(impactGenerator: impactGenerator, identifier: "render_3d", systemName: "view.3d", title: "Stereo Render")
                    StepperSettingView(impactGenerator: impactGenerator, identifier: "factor_3d", systemName: "textformat.123", title: "3D Factor", minValue: 0, maxValue: 100)
                    ToggleSettingView(identifier: "dump_textures", systemName: "arrow.down.doc", title: "Dump Textures", isExperimental: true)
                    ToggleSettingView(identifier: "custom_textures", systemName: "doc.text.magnifyingglass", title: "Custom Textures", isExperimental: true)
                    ToggleSettingView(identifier: "preload_textures", systemName: "arrow.down.doc", title: "Preload Textures", isExperimental: true)
                    ToggleSettingView(identifier: "async_custom_loading", systemName: "leaf", title: "Async Custom Loading", isExperimental: true)
                } header: {
                    Text("Renderer (cont.)")
                }
                .headerProminence(.increased)
            })
            .navigationTitle("Settings")
        }
    }
}
