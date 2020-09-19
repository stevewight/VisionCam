//
//  CapSession.swift
//  VisionCam
//
//  Created by Steve on 8/2/20.
//

import UIKit
import AVFoundation

class CapSession: AVCaptureSession {
    let devices = Devices()
    
    override init() {
        super.init()
        sessionPreset = .medium
    }
    
    public func switchCam() {
        guard let currentInput: AVCaptureInput = inputs.first else {
            return
        }
        beginConfiguration()
        removeInput(currentInput)
        devices.switchCam()
        try? addCurrentDeviceInput()
        commitConfiguration()
    }
    
    public func setUpInputDevice() throws {
        let input = try AVCaptureDeviceInput(
            device: devices.current!
        )
        addInput(input)
    }
    
    public func add(output: CapVidDataOut) {
        if canAddOutput(output) {
            addOutput(output)
        }
    }
    
    private func addCurrentDeviceInput() throws {
        do {
            let input = try AVCaptureDeviceInput(
                device: devices.current!
            )
            addInput(input)
        } catch { print("issue switching input camera") }
    }
    
}
