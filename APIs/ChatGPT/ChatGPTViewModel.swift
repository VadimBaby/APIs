//
//  ChatGPTViewModel.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import Foundation
import CoreData

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
    
    private var tasks: [Task<Void, Never>] = []
    
    init() {
        getEntities()
        getRapidKeyFromUserDefault()
    }
    
    func sendMessage(text: String, setMessageIDToScroll: @escaping (_ id: UUID) -> Void) -> MessageModel {
        let message = MessageModel(text: text, type: .me)
        
        messages.append(message)
        
        sendMessageToChatGPT(text: message.text, setMessageIDToScroll: setMessageIDToScroll)
        
        addMessage(message: message)
        
        return message
    }
    
    func getSectionMessage() -> [[MessageModel]] {
        var res: [[MessageModel]] = []
        var tmp: [MessageModel] = []
        
        for message in messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date)
                if daysBetween >= 1 {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                } else {
                    tmp.append(message)
                }
            } else {
                tmp.append(message)
            }
        }
        res.append(tmp)
        return res
    }
    
    private func getEntities() {
        let request = NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
        
        do {
            let entities: [MessageEntity] = try coreDataManager.context.fetch(request)
            
            messages = entities.compactMap({ entity -> MessageModel? in
                guard let id = entity.id,
                      let text = entity.text,
                      let date = entity.date,
                      let typeString = entity.type,
                      let type = TypeMessage.getTypeMessageFromString(string: typeString)else { return nil }
                
                return MessageModel(id: id, text: text, date: date, type: type)
            }).sorted(by: { $0.date < $1.date })
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @ChatGPTManagerActor
    private func getResponse(text: String, setMessageIDToScroll: (_ id: UUID) -> Void) async {
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
                
                setMessageIDToScroll(answer.id)
                
                addMessage(message: answer)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func sendMessageToChatGPT(text: String, setMessageIDToScroll: @escaping (_ id: UUID) -> Void) {
        let task1 = Task {
            await getResponse(text: text, setMessageIDToScroll: setMessageIDToScroll)
        }
        
        tasks.append(task1)
    }
    
    private func addMessage(message: MessageModel) {
        let newMessage = MessageEntity(context: coreDataManager.context)
        
        newMessage.id = message.id
        newMessage.text = message.text
        newMessage.date = message.date
        newMessage.type = message.type.rawValue
        
        coreDataManager.save()
    }
    
    private func getRapidKeyFromUserDefault() {
        let rapidKey = UserDefaults.standard.string(forKey: "rapidKeyForChatGPT")
        
        guard let rapidKey else { return }
        
        self.rapidKey = rapidKey
    }
    
    func cancel() {
        tasks.forEach{ $0.cancel() }
        tasks = []
    }
}
