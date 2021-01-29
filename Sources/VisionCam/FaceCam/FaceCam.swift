//
//  FaceCam.swift
//  VisionCam
//
//  Created by Steve on 9/7/20.
//

import SwiftUI
import Vision

/**
 View for detecting and tracking all faces within the camera feed.

 Note: The content builder of the method passes an array of VNFaceObservations to use in drawing the UI

 ## Usage
 ~~~
    FaceCam { in observations
        if let firstObservation = observations.first {
            FacePathView(for: firstObservation)
        }
    }
 ~~~
 */
public struct FaceCam<Content>: View where Content: View {
    let builder: ([VNFaceObservation]) -> Content
    @StateObject var vm = FaceCamVM()
    
    /**
     Custom view initializer to provide user with face observations

     - Parameter builder: `@ViewBuilder` providing array of face observations
     - Note: Use the provided array of `VNFaceObservation`'s to draw any custom UI around detected faces
     */
    public init(@ViewBuilder builder: @escaping ([VNFaceObservation]) -> Content) {
        self.builder = builder
    }
    
    /**
     Body of the View

     This is the integration point of the `FaceCamRepresentable` which conforms to the `UIViewControllerRepresentable` protocol and allows us to integrate with UIKit.

     We use a ZStack here to display the video feed from the camera (through `FaceCamRepresentable`) and the user provided custom view on top (through the `@ViewBuilder`).
     */
    public var body: some View {
        ZStack {
            FaceCamRepresentable(vm: vm)
            builder(vm.observations)
        }
    }
}
