//
//  Path+Transform.swift
//  VisionCam
//
//  Created by Steve on 9/3/20.
//

import SwiftUI

extension Path {
    
    /**
    Scale and translation transform to a path with a give y coordinate

     - Parameter newY: The new y coordinate that we need to tranlate the face for
     - Returns: The transformed shape path
     */
    public func faceTransform(newY: CGFloat) -> TransformedShape<TransformedShape<Path>> {
        self.transform(.init(scaleX: 1, y: -1))
            .transform(.init(translationX: 0, y: newY))
    }
    
}
