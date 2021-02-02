//
//  FaceCamRepresentable.swift
//  VisionCam
//
//  Created by Steve on 7/28/20.
//

import Foundation
import UIKit
import SwiftUI
import Vision

/**
 Integration point with UIKit through conformation of `UIViewControllerRepresentable`.

 The `FaceCamVM` is our `ObservableObject` that publishes changes through the `Coordinator`.
 */
struct FaceCamRepresentable: UIViewControllerRepresentable {
    @ObservedObject var vm: FaceCamVM

    func makeUIViewController(context: Context) -> FaceCamController {
        let controller = FaceCamController()
        controller.faceTracker.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ cameraViewController: FaceCamController, context: Context) {
        // update VC with changes from SwiftUI
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /**
     Coordinator for use handling face tracker delegation
     */
    class Coordinator: NSObject, UINavigationControllerDelegate, FaceTrackerDelegate {
        let parent: FaceCamRepresentable

        init(_ parent: FaceCamRepresentable) {
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
