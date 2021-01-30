//
//  FaceTracker.swift
//  VisionCam
//
//  Created by Steve on 8/8/20.
//

import UIKit
import Vision

/**
  Error for handling potential tracking issues
 */
enum TrackError: Error {
    case initialRequest
    case sequenceRequest
    case landmarkRequest
    case faceRequest
}

/**
 Protocol used for face tracking delegation events
 */
protocol FaceTrackerDelegate {
    func faceTracked(observations: [VNFaceObservation])
    func issueTracking(error: TrackError)
}

/**
 Encapsulation of the core face tracking functionality.
 */
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
    
    /**
     Initiate the detection requests
     */
    public func prepare() {
        detectionRequests = [makeFaceRequest()]
    }
    
    /**
        Begin the sequence tracking request.

        If the track request is empty, the initial detection request is performed on the image request, else we continue performing sequence requests.
     */
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
    
    /**
     Initiate the pixel buffer
     */
    private func setBuffer(_ buffer: CMSampleBuffer) {
        pixelBuffer = CMSampleBufferGetImageBuffer(buffer) ?? nil
    }
    
    /**
     Initiate the necessary request options
     */
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
    
    /**
     Perform landmark detection on each of the tracked requests given an input face observation
     */
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
    
    /**
     Tracking request made on subsequent tracking requests

     We check each requests observation for a confidence greater then 0.3 else set as last frame which will be ignored on next iteration
     */
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
    
    /**
     Initial face rectangle request

     It's important to dispatch the setting of the tracked requests on the main thread so as not to block the UI.
     */
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
    
    /**
     Make a single track object request given a specific face observation

     - Parameter observation: A detected face observation
     - Returns: A new track object request
     */
    private func makeTrackReq(_ observation: VNFaceObservation) -> VNTrackObjectRequest {
        VNTrackObjectRequest(detectedObjectObservation: observation)
    }
    
    /**
     Make a face landmark request object

     It's important to dispatch the face tracked delegate method call on the main thread so as not to block the UI.
     */
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
