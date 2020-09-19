//
//  FaceCam.swift
//  VisionCam
//
//  Created by Steve on 9/7/20.
//

import SwiftUI
import Vision

struct FaceCam<Content>: View where Content: View {
    let builder: ([VNFaceObservation]) -> Content
    @ObservedObject var vm = CamVM()
    
    @inlinable init(@ViewBuilder builder: @escaping ([VNFaceObservation]) -> Content) {
        self.builder = builder
    }
    
    var body: some View {
        ZStack {
            CamRepresentable(vm: vm)
            builder(vm.observations)
        }
    }
}
