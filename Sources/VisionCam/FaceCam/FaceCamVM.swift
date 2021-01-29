//
//  FaceCamVM.swift
//  VisionCam
//
//  Created by Steve on 8/21/20.
//

import Foundation
import Combine
import Vision

/**
 Hold and publish changes to face observations and tracking errors
 */
class FaceCamVM: ObservableObject {
    @Published var observations = [VNFaceObservation]()
    @Published var error: TrackError?
}
