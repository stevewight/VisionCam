//
//  CapVidDataOut.swift
//  VisionCam
//
//  Created by Steve on 8/14/20.
//

import Foundation
import AVFoundation

class CapVidDataOut: AVCaptureVideoDataOutput {
    var queue = DispatchQueue(label: "com.vision-cam.pkg")
    
    init(delegate: CamController) {
        super.init()
        alwaysDiscardsLateVideoFrames = true
        setSampleBufferDelegate(delegate, queue: queue)
    }
    
    public func setConnectionMatrixDelivery() {
        if let capCon = connection(with: .video) {
            capCon.isEnabled = true
            if capCon.isCameraIntrinsicMatrixDeliverySupported {
                capCon.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }
    }
    
}
