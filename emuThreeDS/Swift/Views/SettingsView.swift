//
//  SettingsView.swift
//  emuThreeDS
//
//  Created by Antique on 25/5/2023.
//

import Foundation
import SwiftUI

struct ToggleSettingView: View {
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var identifier: String
    var systemName: String
    var title: String
    
    @State var isOn: Bool = false
    var isExperimental: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $isOn) {
                Label(title, systemImage: systemName)
            }
            
            if isExperimental {
                Text("Experimental")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .onChange(of: isOn) { newValue in
            UserDefaults.standard.set(newValue, forKey: identifier)
            impactGenerator.impactOccurred()
        }
        .onAppear {
            isOn = UserDefaults.standard.bool(forKey: identifier)
        }
    }
}

struct SettingsView: View {
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        NavigationView {
            List(content: {
                Section {
                    ToggleSettingView(identifier: "use_cpu_jit", systemName: "cpu", title: "Enable JIT")
                    ToggleSettingView(identifier: "use_hle", systemName: "brain", title: "Enable HLE")
                    CPUClockSettingView(impactGenerator: impactGenerator, identifier: "cpu_clock_percentage", systemName: "percent", title: "CPU Clock")
                    ToggleSettingView(identifier: "is_new_3ds", systemName: "star", title: "Use New 3DS")
                } header: {
                    Text("Core")
                }
                .headerProminence(.increased)
                
                Section {
                    ResolutionFactorSettingView(impactGenerator: impactGenerator, identifier: "resolution_factor", systemName: "aspectratio", title: "Resolution")
                    LayoutOptionSettingView(impactGenerator: impactGenerator, identifier: "portrait_layout_option", systemName: "iphone", title: "Portrait Layout")
                    LayoutOptionSettingView(impactGenerator: impactGenerator, identifier: "landscape_layout_option", systemName: "iphone.landscape", title: "Landscape Layout")
                    ToggleSettingView(identifier: "async_shader_compilation", systemName: "square.stack.3d.down.forward", title: "Async Shaders", isExperimental: true)
                    ToggleSettingView(identifier: "async_presentation", systemName: "videoprojector", title: "Async Presentation", isExperimental: true)
                    ToggleSettingView(identifier: "use_hw_shader", systemName: "square.stack.3d.down.forward", title: "Enable HW Shaders", isExperimental: true)
                } header: {
                    Text("Renderer")
                }
                .headerProminence(.increased)
            })
            .navigationTitle("Settings")
        }
    }
}
