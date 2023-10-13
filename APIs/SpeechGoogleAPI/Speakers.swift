//
//  Speakers.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import Foundation

enum Speakers: String, Equatable, CaseIterable {
    case joanna = "Joanna"
    case wavenet_b = "Wavenet-B"
    case amy = "Amy"
    case salli = "Salli"
    case brian = "Brian"
    case matthew = "Matthew"
    case wavenet_a = "Wavenet-A"
    
    func getVoiceParameter() -> VoiceParameterModel {
        switch self {
        case .joanna:
            return VoiceParameterModel(name: self.rawValue, engine: .neural, languageCode: .en_us)
        case .wavenet_b:
            return VoiceParameterModel(name: self.rawValue, engine: .google, languageCode: .en_in)
        case .amy:
            return VoiceParameterModel(name: self.rawValue, engine: .neural, languageCode: .en_gb)
        case .salli:
            return VoiceParameterModel(name: self.rawValue, engine: .neural, languageCode: .en_us)
        case .brian:
            return VoiceParameterModel(name: self.rawValue, engine: .neural, languageCode: .en_gb)
        case .matthew:
            return VoiceParameterModel(name: self.rawValue, engine: .neural, languageCode: .en_us)
        case .wavenet_a:
            return VoiceParameterModel(name: self.rawValue, engine: .google, languageCode: .en_in)
        }
    }
    
    static func getVoiceFromString(value: String) -> Speakers {
        switch value {
        case "Joanna":
            return .joanna
        case "Wavenet-B":
            return .wavenet_b
        case "Amy":
            return .amy
        case "Salli":
            return .salli
        case "Brian":
            return .brian
        case "Matthew":
            return .matthew
        case "Wavenet-A":
            return .wavenet_a
        default:
            return .joanna
        }
    }
}
