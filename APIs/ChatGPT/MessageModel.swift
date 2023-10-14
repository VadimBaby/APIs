//
//  MessageModel.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import Foundation

enum TypeMessage: String {
    case me
    case chatgpt
    
    static func getTypeMessageFromString(string: String) -> TypeMessage? {
        switch string {
        case "me":
            return .me
        case "chatgpt":
            return .chatgpt
        default:
            return nil
        }
    }
}

struct MessageModel: Identifiable {
    let id: UUID
    let text: String
    let date: Date
    let type: TypeMessage
    
    init(id: UUID, text: String, date: Date, type: TypeMessage) {
        self.id = id
        self.text = text
        self.date = date
        self.type = type
    }
    
    init(text: String, type: TypeMessage) {
        self.id = UUID()
        self.text = text
        self.date = Date()
        self.type = type
    }
}
