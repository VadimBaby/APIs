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
    
    private let manager = ChatGPTManagerActor.shared
    
    private let coreDataManager = CoreDataManager.instance
    
    @ChatGPTManagerActor
    private func getResponse(text: String) async {
        do {
            let data = try await manager.getResponse(text: text, rapidKey: rapidKey)
            
            let response = try JSONDecoder().decode(ChatGPTResponseModel.self, from: data)
            
            var answerText: String {
                if let text = response.text {
                    return text
                } else if let message = response.message {
                    return message
                } else {
                    return "Error"
                }
            }
            
            await MainActor.run {
                let answer: MessageModel = MessageModel(text: answerText, type: .chatgpt)
                
                self.messages.append(answer)
                
                addMessage(message: answer)
            }
        } catch {
            print(error)
        }
    }
    
    private func addMessage(message: MessageModel) {
        let newMessage = MessageEntity(context: coreDataManager.context)
        
        newMessage.id = message.id
        newMessage.text = message.text
        newMessage.date = message.date
        newMessage.type = message.type.rawValue
        
        coreDataManager.save()
    }
}
