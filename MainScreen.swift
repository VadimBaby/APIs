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
            SpeechGoogleAPIView()
                .tabItem {
                    Image(systemName: "waveform")
                    Text("Speech")
                }
            
            ChatGPTView()
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
