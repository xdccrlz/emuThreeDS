//
//  CPUClockSettingView.swift
//  emuThreeDS
//
//  Created by Antique on 1/6/2023.
//

import SwiftUI

struct CPUClockSettingView: View {
    var impactGenerator: UIImpactFeedbackGenerator
    
    var identifier: String
    var systemName: String
    var title: String

    @State var value: Int = 100
    
    var body: some View {
        Stepper(value: $value, in: 5...400, step: 5) {
            HStack {
                VStack(alignment: .leading) {
                    Label(title, systemImage: systemName)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(value)%")
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            let percentage = UserDefaults.standard.integer(forKey: identifier)
            value = percentage == 0 ? 100 : percentage
        }
        .onChange(of: value) { newValue in
            UserDefaults.standard.set(newValue, forKey: identifier)
        }
    }
}
