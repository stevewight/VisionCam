//
//  View+Transform.swift
//  HackCam
//
//  Created by Steve on 9/11/20.
//

import SwiftUI

extension View {
    
    func path(in rect: CGRect) -> some View {
        frame(
            width: rect.width,
            height: rect.height,
            alignment: .center
        )
        .position(
            x: rect.midX,
            y: rect.midY
        )
    }
    
    func faceTransform(newY: CGFloat) -> some View {
        transformEffect(.init(scaleX: 1, y: -1))
        .transformEffect(.init(translationX: 0, y: newY))
    }
    
}
