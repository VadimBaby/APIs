//
//  MainScreen.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        TabView {
            Text("Speech")
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Speech")
                }
            
            Text("ChatGPT")
                .tabItem {
                    Image(systemName: "message")
                    Text("ChatGPT")
                }
        }
        .tint(Color.red)
    }
}

#Preview {
    MainScreen()
}
