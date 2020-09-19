//
//  VNFaceObservation+CGRect.swift
//  HackCam
//
//  Created by Steve on 8/17/20.
//

import Foundation
import Vision

extension VNFaceObservation {
    
    public func boxRect(size: CGSize) -> CGRect? {
        VNImageRectForNormalizedRect(
            boundingBox,
            Int(size.width),
            Int(size.height)
        )
    }
    
    public func openRegions() -> [VNFaceLandmarkRegion2D?] {
        guard let lm = landmarks else { return [] }
        return [
            lm.leftEyebrow,
            lm.rightEyebrow,
            lm.faceContour,
            lm.noseCrest,
            lm.medianLine
        ]
    }
    
    public func closedRegions() -> [VNFaceLandmarkRegion2D?] {
        guard let lm = landmarks else { return [] }
        return [
            lm.leftEye,
            lm.rightEye,
            lm.outerLips,
            lm.innerLips,
            lm.nose
        ]
    }
    
}
