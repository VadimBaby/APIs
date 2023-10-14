//
//  ChatGPTViewModel.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import Foundation

@MainActor
final class ChatGPTViewModel: ObservableObject {
    
    @Published private(set) var messages: [MessageModel] = []
    
    @Published public var rapidKey: String = ChatGPTConstants.rapidKey {
        didSet {
            if !rapidKey.isEmpty {
                UserDefaults.standard.set(rapidKey, forKey: "rapidKeyForChatGPT")
            }
        }
    }
}
