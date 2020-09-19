//
//  CamController.swift
//  VisionCam
//
//  Created by Steve on 7/28/20.
//

import UIKit
import AVFoundation

class CamController: UIViewController {
    var session = CapSession()
    var preview = CamPreview()
    var faceTracker = FaceTracker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public func didTapCamSwitch() {
        session.switchCam()
    }
    
    private func setup() {
        faceTracker.prepare()
        setUpInputOutput()
        preview.set(session: session, view: view)
        session.startRunning()
    }
    
    private func setUpInputOutput() {
        do {
            try session.setUpInputDevice()
            let capVideoOut = CapVidDataOut(delegate: self)
            session.add(output: capVideoOut)
            capVideoOut.setConnectionMatrixDelivery()
        } catch { print(error) }
    }
    
}

extension CamController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let capOut = CapOutput(buffer: sampleBuffer, output: output)
        faceTracker.handle(capture: capOut)
    }
    
}
