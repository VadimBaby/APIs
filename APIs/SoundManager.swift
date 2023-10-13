//
//  SoundManager.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import Foundation
import AVKit

class SoundManager {
    static let instanse = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSoundFromData(data: Data) throws -> AVAudioPlayer {
        do {
            player = try AVAudioPlayer(data: data)
            
            guard let player else { throw Errors.playerIsNil }
            
            return player
        } catch {
            print("that shit")
            throw error
        }
    }
}
