//
//  CamPreview.swift
//  VisionCam
//
//  Created by Steve on 8/2/20.
//

import UIKit
import AVFoundation

/**
 Encapsulates the video preview layer and necessary configurations
 */
class CamPreview: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var video: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    /**
     Set video layer on given view and configure

     - Parameters:
        - session: capture session that should be set on video preview layer
        - view: UIView to insert the video preview layer as sub layer to
     */
    public func set(session: AVCaptureSession, view: UIView) {
        video.session = session
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        video.frame = view.frame
        view.layer.insertSublayer(video, at: 0)
    }
    
}
