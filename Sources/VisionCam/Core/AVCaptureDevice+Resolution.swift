//
//  AVCaptureDevice+Resolution.swift
//  VisionCam
//
//  Created by Steve on 8/22/20.
//

import Foundation
import AVFoundation

extension AVCaptureDevice {
    
    /**
    Helper method to find the highest resolution 420 format for the current capture device

     - Returns: Tuple that holds both the device format and resolution calculated
     */
    public func highestRes420Format() -> (format: AVCaptureDevice.Format, resolution: CGSize)? {
        var highFormat: AVCaptureDevice.Format? = nil
        var highDimensions = CMVideoDimensions(width: 0, height: 0)
        
        for format in formats {
            let deviceFormat = format as AVCaptureDevice.Format
            
            let deviceFormatDescription = deviceFormat.formatDescription
            if CMFormatDescriptionGetMediaSubType(deviceFormatDescription) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
                let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)
                if (highFormat == nil) || (candidateDimensions.width > highDimensions.width) {
                    highFormat = deviceFormat
                    highDimensions = candidateDimensions
                }
            }
        }
        
        if highFormat != nil {
            let resolution = CGSize(width: CGFloat(highDimensions.width), height: CGFloat(highDimensions.height))
            return (highFormat!, resolution)
        }
        
        return nil
    }
    
}
