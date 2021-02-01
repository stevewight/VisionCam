//
//  View+Transform.swift
//  VisionCam
//
//  Created by Steve on 9/11/20.
//

import SwiftUI

extension View {
    
    /**
    The path of a view in a given rect

     - Parameter rect: The rectangle to find that path in
     - Returns: The view with altered frame and position
     */
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
    
    /**
    Scale and translation transform to a view with a give y coordinate

     - Parameter newY: The new y coordinate that we need to tranlate the face for
     - Returns: The transformed view
     */
    public func faceTransform(newY: CGFloat) -> some View {
        transformEffect(.init(scaleX: 1, y: -1))
        .transformEffect(.init(translationX: 0, y: newY))
    }
    
}
