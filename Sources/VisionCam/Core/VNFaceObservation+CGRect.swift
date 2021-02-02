//
//  VNFaceObservation+CGRect.swift
//  VisionCam
//
//  Created by Steve on 8/17/20.
//

import Foundation
import Vision

extension VNFaceObservation {
    
    /**
     Normalize a face observations rectangle

     - Parameter size: The size of the box rectangle to be normalized to
     - Return: The normalized rectangle
     */
    public func boxRect(size: CGSize) -> CGRect? {
        VNImageRectForNormalizedRect(
            boundingBox,
            Int(size.width),
            Int(size.height)
        )
    }
    
    /**
     Helper method to get the open landmark regions from a face observation

     - Returns: An array of the 2D face landmark regions for the current face observation
     */
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
    
    /**
    Helper method to get the closed landmark regions from a face observation

     - Returns: An array of 2D face landmark regions for the current face observation
     */
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
