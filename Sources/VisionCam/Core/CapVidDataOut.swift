//
//  CapVidDataOut.swift
//  VisionCam
//
//  Created by Steve on 8/14/20.
//

import Foundation
import AVFoundation

/**
 Encapsulation of capture video data output
 */
class CapVidDataOut: AVCaptureVideoDataOutput {
    var queue = DispatchQueue(label: "com.vision-cam.pkg")
    
    /**
     Custom initializer

     - Parameter delegate: cam controller thats set as the sample buffer delegate

     - Todo: refactor delegate parameter to be generic
     */
    init(delegate: FaceCamController) {
        super.init()
        alwaysDiscardsLateVideoFrames = true
        setSampleBufferDelegate(delegate, queue: queue)
    }
    
    /**
     Setting up cameras matrix delivery support
     */
    public func setConnectionMatrixDelivery() {
        if let capCon = connection(with: .video) {
            capCon.isEnabled = true
            if capCon.isCameraIntrinsicMatrixDeliverySupported {
                capCon.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
    }
    
}
