//
//  CapOutput.swift
//  VisionCam
//
//  Created by Steve on 8/8/20.
//

import Foundation
import AVFoundation

/**
 Encapsulation of sample buffer and capture output
 */
struct CapOutput {
    let buffer: CMSampleBuffer
    let output: AVCaptureOutput
}
