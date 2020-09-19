//
//  CamRepresentable.swift
//  VisionCam
//
//  Created by Steve on 7/28/20.
//

import Foundation
import UIKit
import SwiftUI
import Vision

struct CamRepresentable: UIViewControllerRepresentable {
    @ObservedObject var vm: CamVM

    func makeUIViewController(context: Context) -> CamController {
        let controller = CamController()
        controller.faceTracker.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ cameraViewController: CamController, context: Context) {
        // update VC with changes from SwiftUI
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, FaceTrackerDelegate {
        let parent: CamRepresentable

        init(_ parent: CamRepresentable) {
            self.parent = parent
        }
        
        func faceTracked(observations: [VNFaceObservation]) {
            DispatchQueue.main.async { [self] in
                parent.vm.observations = observations
            }
        }
        
        func issueTracking(error: TrackError) {
            parent.vm.error = error
        }
    }
}
