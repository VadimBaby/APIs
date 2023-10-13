//
//  SpeechGoogleAPIDataManager.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import Foundation

enum SpeechGoogleAPIConstants {
    static let rapidKey = "6e1559cd5cmshe03d10503cdd912p1a37bbjsn4f0eda215448"
    static let url = "https://text-to-speech-neural-google.p.rapidapi.com/generateAudioFiles"
}

@globalActor struct SpeechGoogleActor {
    static var shared = SpeechGoogleAPIDataManager()
}

actor SpeechGoogleAPIDataManager {
    
    func getResponse(text: String, voiceParameter: VoiceParameterModel, rapidKey: String) async throws -> Data {
        
        let headers = [
            "content-type": "application/json",
            "X-RapidAPI-Key": rapidKey,
            "X-RapidAPI-Host": "text-to-speech-neural-google.p.rapidapi.com"
        ]
        
        let parameters = [
            "audioFormat": "mp3",
            "paragraphChunks": [text],
            "voiceParams": [
                "name": voiceParameter.name,
                "engine": voiceParameter.engine.rawValue,
                "languageCode": voiceParameter.languageCode.rawValue
            ]
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let postData else { throw Errors.JSONSerializationFailder }
        
        guard let url = URL(string: SpeechGoogleAPIConstants.url) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        do {
            let (response, _) = try await URLSession.shared.data(for: request)

            return response
        } catch {
            throw error
        }
    }
}
