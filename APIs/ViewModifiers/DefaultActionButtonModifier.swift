//
//  DefaultActionButtonModifier.swift
//  APIs
//
//  Created by Вадим Мартыненко on 15.10.2023.
//

import Foundation
import SwiftUI

struct DefaultActionButtonModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .tint(Color.white)
            .padding()
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 15))
    }
}
