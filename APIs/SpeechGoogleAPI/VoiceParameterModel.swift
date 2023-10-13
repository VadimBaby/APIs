//
//  VoiceParameterModel.swift
//  APIs
//
//  Created by Вадим Мартыненко on 13.10.2023.
//

import Foundation

enum Engine: String {
    case google
    case neural
}

enum LanguageCode: String {
    case en_us = "en-US"
    case en_in = "en-IN"
    case en_gb = "en-GB"
}

struct VoiceParameterModel {
    let name: String
    let engine: Engine
    let languageCode: LanguageCode
}
