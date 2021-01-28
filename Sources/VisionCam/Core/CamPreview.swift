//
//  CamPreview.swift
//  VisionCam
//
//  Created by Steve on 8/2/20.
//

import UIKit
import AVFoundation

class CamPreview: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var video: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    public func set(session: AVCaptureSession, view: UIView) {
        video.session = session
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        video.frame = view.frame
        view.layer.insertSublayer(video, at: 0)
    }
    
}
