//
//  ItemModifier.swift
//  Petnote
//
//  Created by João Marcelo Colombini Cardonha on 20/02/25.
//

import Foundation
import SwiftUICore

struct ItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding(11)
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
