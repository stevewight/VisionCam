//
//  Devices.swift
//  VisionCam
//
//  Created by Steve on 8/1/20.
//

import UIKit
import AVFoundation

class Devices {
    var front: AVCaptureDevice?
    var back: AVCaptureDevice?
    var current: AVCaptureDevice? {
        didSet {
            setResolution()
        }
    }
    var currentResolution: CGSize?
    
    static var orientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            return .rightMirrored
        case .landscapeLeft:
            return .downMirrored
        case .landscapeRight:
            return .upMirrored
        default:
            return .leftMirrored
        }
    }
    
    var discovery: AVCaptureDevice.DiscoverySession {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: AVCaptureDevice.Position.unspecified
        )
    }
    
    init() {
        setDevices()
    }
    
    public func switchCam() {
        if current == front {
            current = back
        } else {
            current = front
        }
    }
    
    private func setDevices() {
        
        for device in discovery.devices {
            switch device.position {
            case AVCaptureDevice.Position.front:
                front = device
            case AVCaptureDevice.Position.back:
                back = device
            default:
                break
            }
        }
        
        current = front
    }
    
    private func setResolution() {
        guard let current = current else { return }
        if let highRes = current.highestRes420Format() {
            do {
                try current.lockForConfiguration()
                current.activeFormat = highRes.format
                current.unlockForConfiguration()
                currentResolution = highRes.resolution
            } catch { print("issues setting resolution") }
        }
    }
    
}
