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
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Label(title, systemImage: systemName)
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


enum ResolutionFactors : Int, CaseIterable, CustomStringConvertible, Identifiable {
    var id: Self {
        return self
    }
    
    case zero, one, two, three, four, five, six, seven, eight, nine, ten
    
    var description: String {
        switch self {
        case .zero:
            return "0"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .ten:
            return "10"
        }
    }
}


struct ResolutionFactorSettingView: View {
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var identifier: String
    var systemName: String
    var title: String
    
    @State var selectedItem: ResolutionFactors = .zero
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .renderingMode(.template)
                .foregroundColor(.yellow)
            Picker(title, selection: $selectedItem) {
                ForEach(ResolutionFactors.allCases, id: \.id) { resolution in
                    let topResH = 240, bottomResH = 320
                    
                    Text("\(topResH * resolution.rawValue)p, \(bottomResH * resolution.rawValue)p")
                }
            }
        }
        .onAppear {
            selectedItem = ResolutionFactors(rawValue: UserDefaults.standard.integer(forKey: identifier)) ?? .zero
        }
        .onChange(of: selectedItem, perform: { newValue in
            UserDefaults.standard.set(selectedItem.rawValue, forKey: identifier)
            impactGenerator.impactOccurred()
        })
        .pickerStyle(.navigationLink)
    }
}


enum LayoutOptions : Int, CaseIterable, CustomStringConvertible, Identifiable {
    var id: Self {
        return self
    }
    
    case defaultOption = 0, singleScreen = 1, largeScreen = 2, sideScreen = 3, mobilePortrait = 5, mobileLandscape = 6
    
    var description: String {
        switch self {
        case .defaultOption:
            return "Default"
        case .singleScreen:
            return "Single Screen"
        case .largeScreen:
            return "Large Screen"
        case .sideScreen:
            return "Side Screen"
        case .mobilePortrait:
            return "Mobile Portrait"
        case .mobileLandscape:
            return "Mobile Landscape"
        }
    }
}


struct LayoutOptionSettingView: View {
    var impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var identifier: String
    var systemName: String
    var title: String
    
    @State var selectedItem: LayoutOptions = .defaultOption
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: systemName)
                    .renderingMode(.template)
                    .foregroundColor(.yellow)
                Picker(title, selection: $selectedItem) {
                    ForEach(LayoutOptions.allCases, id: \.id) { layoutOption in
                        Text(layoutOption.description)
                    }
                }
            }
            Text("Experimental")
                .font(.caption)
                .foregroundColor(.orange)
        }
        .onAppear {
            selectedItem = LayoutOptions(rawValue: UserDefaults.standard.integer(forKey: identifier)) ?? .defaultOption
        }
        .onChange(of: selectedItem, perform: { newValue in
            UserDefaults.standard.set(selectedItem.rawValue, forKey: identifier)
            impactGenerator.impactOccurred()
        })
        .pickerStyle(.navigationLink)
    }
}



struct SettingsView: View {
    var body: some View {
        NavigationView {
            List(content: {
                Section {
                    ToggleSettingView(identifier: "use_cpu_jit", systemName: "cpu", title: "Use JIT")
                    ToggleSettingView(identifier: "use_hle", systemName: "brain", title: "Use HLE")
                } header: {
                    Text("Core")
                }
                .headerProminence(.increased)
                
                Section {
                    ResolutionFactorSettingView(identifier: "resolution_factor", systemName: "aspectratio", title: "Resolution")
                    LayoutOptionSettingView(identifier: "portrait_layout_option", systemName: "iphone", title: "Portrait Layout")
                    LayoutOptionSettingView(identifier: "landscape_layout_option", systemName: "iphone.landscape", title: "Landscape Layout")
                } header: {
                    Text("Renderer")
                }
                .headerProminence(.increased)
            })
            .navigationTitle("Settings")
        }
    }
}
