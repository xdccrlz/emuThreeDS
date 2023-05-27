//
//  SettingsView.swift
//  emuThreeDS
//
//  Created by Antique on 25/5/2023.
//

import SwiftUI

struct SettingView: View {
    var systemName: String
    var title: String
    
    var body: some View {
        Label(title, systemImage: systemName)
    }
}

struct ToggleSettingView: View {
    var systemName: String
    var title: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Label(title, systemImage: systemName)
            }
            
            VStack(alignment: .trailing) {
                Toggle("", isOn: .constant(false))
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List(content: {
                Section {
                    ToggleSettingView(systemName: "cpu", title: "JIT")
                    SettingView(systemName: "speedometer", title: "CPU Clock Percentage")
                    ToggleSettingView(systemName: "star", title: "New 3DS")
                } header: {
                    Text("Core")
                }
                .headerProminence(.increased)
                
                Section(content: {
                    SettingView(systemName: "internaldrive", title: "Virtual SD")
                    SettingView(systemName: "internaldrive", title: "Custom Storage")
                }, header: {
                    Text("Data Storage")
                })
                .headerProminence(.increased)
                
                Section(content: {
                    ToggleSettingView(systemName: "ladybug", title: "Debug")
                    ToggleSettingView(systemName: "", title: "Hardware Shader")
                    ToggleSettingView(systemName: "internaldrive", title: "Disk Shader Cache")
                    // shaders accurate mul
                    ToggleSettingView(systemName: "", title: "New VSync")
                    ToggleSettingView(systemName: "cpu", title: "Shader JIT")
                    SettingView(systemName: "aspectratio", title: "Resolution Factor")
                    SettingView(systemName: "tortoise", title: "Frame Limit")
                    SettingView(systemName: "camera.filters", title: "Texture Filter")
                }, header: {
                    Text("Renderer")
                })
                .headerProminence(.increased)
            })
            .navigationTitle("Settings")
        }
    }
}
