//
//  SpeechGoogleAPIViewModel.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import Foundation
import AVKit

final class SpeechGoogleAPIViewModel: ObservableObject {
    
    @MainActor @Published private(set) var voice: AVAudioPlayer? = nil
    
    @MainActor @Published private(set) var isPlaying: Bool = false
    
    @MainActor @Published private(set) var currentTime: TimeInterval? = nil
    
    @MainActor @Published private(set) var isLoading: Bool = false
    
    @MainActor @Published private(set) var error: URLError? = nil
    
    @MainActor @Published public var speaker: Speakers = .joanna {
        didSet {
            UserDefaults.standard.set(speaker.rawValue, forKey: "speaker")
        }
    }
    
    @MainActor @Published public var rapidKey: String = SpeechGoogleAPIConstants.rapidKey {
        didSet {
            guard !rapidKey.isEmpty else { return }
            
            UserDefaults.standard.set(rapidKey, forKey: "rapidKeyForGoogleSpeech")
        }
    }
    
    private let manager = SpeechGoogleActor.shared
    
    private let soundManager = SoundManager.instanse
    
    private var tasks: [Task<Void, Never>] = []
    
    @MainActor
    init() {
        getDataFromUserDefaults()
    }
    
    func getVoice(text: String) {
         let task = Task {
             do {
                 
                 await MainActor.run {
                     self.isLoading = true
                 }
                 
                 let voiceParameter: VoiceParameterModel = await speaker.getVoiceParameter()
                 
                 let response = try await manager.getResponse(text: text, voiceParameter: voiceParameter, rapidKey: self.rapidKey)
                  
                 let audioStream = try JSONDecoder().decode(SpeechGoogleAPIModel.self, from: response).audioStream
                  
                 await MainActor.run {
                      do {
                          self.voice = try soundManager.playSoundFromData(data: audioStream)
                          self.error = nil
                          self.currentTime = voice?.currentTime
                      } catch {
                          self.error = URLError(.badServerResponse)
                          print(error.localizedDescription)
                      }
                     
                     self.isLoading = false
                  }
             } catch {
                 await MainActor.run {
                     self.isLoading = false
                     self.error = URLError(.badServerResponse)
                 }
                 print(error.localizedDescription)
             }
        }
        
        tasks.append(task)
    }
    
    func cancel() {
        tasks.forEach{ $0.cancel() }
        tasks = []
    }
    
    @MainActor private func getDataFromUserDefaults() {
        let speakerString = UserDefaults.standard.string(forKey: "speaker")
        
        if let speakerString {
            self.speaker = Speakers.getVoiceFromString(value: speakerString)
        }
        
        let rapidKey = UserDefaults.standard.string(forKey: "rapidKeyForGoogleSpeech")
        
        if let rapidKey {
            self.rapidKey = rapidKey
        }
    }
}
