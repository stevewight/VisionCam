//
//  View+Transform.swift
//  VisionCam
//
//  Created by Steve on 9/11/20.
//

import SwiftUI

extension View {
    
    public func path(in rect: CGRect) -> some View {
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
    
    public func faceTransform(newY: CGFloat) -> some View {
        transformEffect(.init(scaleX: 1, y: -1))
        .transformEffect(.init(translationX: 0, y: newY))
    }
    
}
