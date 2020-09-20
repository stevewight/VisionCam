//
//  Path+Transform.swift
//  HackCam
//
//  Created by Steve on 9/3/20.
//

import SwiftUI

extension Path {
    
    public func faceTransform(newY: CGFloat) -> TransformedShape<TransformedShape<Path>> {
        self.transform(.init(scaleX: 1, y: -1))
            .transform(.init(translationX: 0, y: newY))
    }
    
}
