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
}
