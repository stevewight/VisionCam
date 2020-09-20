//
//  FaceCam.swift
//  VisionCam
//
//  Created by Steve on 9/7/20.
//

import SwiftUI
import Vision

public struct FaceCam<Content>: View where Content: View {
    let builder: ([VNFaceObservation]) -> Content
    @ObservedObject var vm = CamVM()
    
    public init(@ViewBuilder builder: @escaping ([VNFaceObservation]) -> Content) {
        self.builder = builder
    }
    
    public var body: some View {
        ZStack {
            CamRepresentable(vm: vm)
            builder(vm.observations)
        }
    }
}
