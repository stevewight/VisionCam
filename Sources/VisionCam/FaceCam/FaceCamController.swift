//
//  FaceCamController.swift
//  VisionCam
//
//  Created by Steve on 7/28/20.
//

import UIKit
import AVFoundation

/**
 UIViewController subclass for integrating capture session, camera preview and face tracking.
 */
class FaceCamController: UIViewController {
    var session = CapSession()
    var preview = CamPreview()
    var faceTracker = FaceTracker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /**
     Switch camera hardware device that is providing the pixel buffer (front/back)
     */
    public func didTapCamSwitch() {
        session.switchCam()
    }
    
    /**
     Setup the face tracker, input, output, preview and start the session.
     */
    private func setup() {
        faceTracker.prepare()
        setUpInputOutput()
        preview.set(session: session, view: view)
        session.startRunning()
    }
    
    /**
     Initiate the sessions input device and add the captured video output.

    - Todo: Throw a proper error when input device setup fails.
     */
    private func setUpInputOutput() {
        do {
            try session.setUpInputDevice()
            let capVideoOut = CapVidDataOut(delegate: self)
            session.add(output: capVideoOut)
            capVideoOut.setConnectionMatrixDelivery()
        } catch { print(error) }
    }
    
}

extension FaceCamController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /**
     Conform to `AVCaptureVideoDataOutputSampleBufferDelegate` to recieve the pixel buffer and pass it to the `FaceTracker` for processing.
     */
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let capOut = CapOutput(buffer: sampleBuffer, output: output)
        faceTracker.handle(capture: capOut)
    }
    
}
