//
//  FaceTracker.swift
//  VisionCam
//
//  Created by Steve on 8/8/20.
//

import UIKit
import Vision

enum TrackError: Error {
    case initialRequest
    case sequenceRequest
    case landmarkRequest
    case faceRequest
}

protocol FaceTrackerDelegate {
    func faceTracked(observations: [VNFaceObservation])
    func issueTracking(error: TrackError)
}

class FaceTracker {
    var delegate: FaceTrackerDelegate?
    var pixelBuffer: CVImageBuffer?
    var requestOptions: [VNImageOption: AnyObject] = [:]
    
    lazy var sequenceRequest = VNSequenceRequestHandler()
    var detectionRequests: [VNDetectFaceRectanglesRequest]?
    var trackRequests = [VNTrackObjectRequest]()
    
    var imageRequest: VNImageRequestHandler? {
        guard let pBuffer = pixelBuffer else { return nil }
        return VNImageRequestHandler(
            cvPixelBuffer: pBuffer,
            orientation: Devices.orientation,
            options: requestOptions
        )
    }
    
    public func prepare() {
        detectionRequests = [makeFaceRequest()]
    }
    
    public func handle(capture: CapOutput) {
        
        setBuffer(capture.buffer)
        
        if trackRequests.isEmpty {
            
            self.delegate?.faceTracked(observations: [])
            do {
                setRequestOptions(capture.buffer)
                guard let imageRequest = imageRequest,
                      let detectionRequests = detectionRequests else {
                    return
                }
                try imageRequest.perform(detectionRequests)
            } catch { self.delegate?.issueTracking(error: .initialRequest) }
        } else {
            
            do {
                guard let pixelBuffer = pixelBuffer else { return }
                try sequenceRequest.perform(
                    trackRequests,
                    on: pixelBuffer,
                    orientation: Devices.orientation
                )
            } catch { self.delegate?.issueTracking(error: .sequenceRequest) }
            
            if let nextRequests = makeNextTrackingRequests() {
                trackRequests = nextRequests
            }
            if trackRequests.isEmpty { return }
            performLandmarkDetection()
        }
        
    }
    
    private func setBuffer(_ buffer: CMSampleBuffer) {
        pixelBuffer = CMSampleBufferGetImageBuffer(buffer) ?? nil
    }
    
    private func setRequestOptions(_ buffer: CMSampleBuffer) {
        let intrinsicData = CMGetAttachment(
            buffer,
            key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix,
            attachmentModeOut: nil
        )
        if intrinsicData != nil {
            requestOptions[VNImageOption.cameraIntrinsics] = intrinsicData
        }
    }
    
    private func performLandmarkDetection() {
        var newRequests = [VNDetectFaceLandmarksRequest]()
        
        for request in trackRequests {
            let landmarkRequest = makeLandmarkRequest()
            
            guard let observation = request.results?.first as? VNDetectedObjectObservation else { return }
            
            let faceObservation = VNFaceObservation(boundingBox: observation.boundingBox)
            landmarkRequest.inputFaceObservations = [faceObservation]
            newRequests.append(landmarkRequest)
            
            guard let imageRequest = imageRequest else { return }
            
            do {
                try imageRequest.perform(newRequests)
            } catch { self.delegate?.issueTracking(error: .landmarkRequest) }
        }
    }
    
    private func makeNextTrackingRequests() -> [VNTrackObjectRequest]? {
        var newRequests = [VNTrackObjectRequest]()
        for request in trackRequests {
            
            guard let observation = request.results?.first as? VNDetectedObjectObservation else { return nil }
            
            if !request.isLastFrame {
                if observation.confidence > 0.3 {
                    request.inputObservation = observation
                } else {
                    request.isLastFrame = true
                }
                newRequests.append(request)
            }
        }
        return newRequests
    }
    
    private func makeFaceRequest() -> VNDetectFaceRectanglesRequest {
        VNDetectFaceRectanglesRequest { req, err in
            if err != nil {
                self.delegate?.issueTracking(error: .faceRequest)
            }
            
            guard let results = req.results as? [VNFaceObservation] else {
                return
            }
            
            DispatchQueue.main.async {
                self.trackRequests = results.map { self.makeTrackReq($0) }
            }
        }
    }
    
    private func makeTrackReq(_ observation: VNFaceObservation) -> VNTrackObjectRequest {
        VNTrackObjectRequest(detectedObjectObservation: observation)
    }
    
    private func makeLandmarkRequest() -> VNDetectFaceLandmarksRequest {
        VNDetectFaceLandmarksRequest { req, err in
            if err != nil {
                self.delegate?.issueTracking(error: .landmarkRequest)
            }
            
            guard let results = req.results as? [VNFaceObservation] else {
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.faceTracked(observations: results)
            }
        }
    }
    
}
