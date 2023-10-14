//
//  ChatGPTManager.swift
//  APIs
//
//  Created by Вадим Мартыненко on 14.10.2023.
//

import Foundation

enum ChatGPTConstants {
    static let rapidKey = "0ee6652a40mshb2a06f6f8ed8e7fp129ce4jsnb16762573247"
    static let url = "https://chatgpt-api8.p.rapidapi.com/"
}

@globalActor struct ChatGPTManagerActor {
    static var shared = ChatGPTManager()
}

actor ChatGPTManager {
    func getResponse(text: String, rapidKey: String) async throws -> Data {
        let headers = [
            "content-type": "application/json",
            "X-RapidAPI-Key": rapidKey,
            "X-RapidAPI-Host": "chatgpt-api8.p.rapidapi.com"
        ]
        let parameters = [
            [
                "content": text,
                "role": "user"
            ] as [String : Any]
        ]

        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let url = URL(string: ChatGPTConstants.url) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let (response, _) = try await URLSession.shared.data(for: request)
        
        return response
    }
}
