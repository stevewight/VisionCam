//
//  CapSession.swift
//  VisionCam
//
//  Created by Steve on 8/2/20.
//

import UIKit
import AVFoundation

/**
 Holds the `Devices` class and provides interface for adding video data output and switching between cameras
 */
class CapSession: AVCaptureSession {
    let devices = Devices()
    
    override init() {
        super.init()
        sessionPreset = .medium
    }
    
    /**
     Toggle between cameras (front/back) and handle necessary configurations
     */
    public func switchCam() {
        guard let currentInput: AVCaptureInput = inputs.first else {
            return
        }
        beginConfiguration()
        removeInput(currentInput)
        devices.switchCam()
        try? setUpInputDevice()
        commitConfiguration()
    }
    
    /**
    Set up capture device input with current device and add to the session
     */
    public func setUpInputDevice() throws {
        let input = try AVCaptureDeviceInput(
            device: devices.current!
        )
        addInput(input)
    }
    
    /**
     Add video data output to the capture session

     - Parameter output: video data output to add to the capture session
     */
    public func add(output: CapVidDataOut) {
        if canAddOutput(output) {
            addOutput(output)
        }
    }
    
}
