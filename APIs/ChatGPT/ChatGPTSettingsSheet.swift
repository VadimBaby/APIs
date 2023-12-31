//
//  ChatGPTSettingsSheet.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import SwiftUI

struct ChatGPTSettingsSheet: View {
    
    @Binding var text: String
    
    var body: some View {
        VStack{
            TextField("API KEY", text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 15))
            HStack{
                Button(action: {
                    text = ChatGPTConstants.rapidKey
                }, label: {
                    Text("Paste Default API KEY")
                        .withDefaultActionButtonFormatting(Color.green)
                })
                Spacer()
                Button(action: {
                    text = ""
                }, label: {
                    Text("Clear")
                        .withDefaultActionButtonFormatting(Color.red)
                })
            }
        }
        .padding()
    }
}

#Preview {
    ChatGPTSettingsSheet(text: .constant(""))
}
