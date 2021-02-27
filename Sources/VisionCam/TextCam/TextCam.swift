//
//  TextCam.swift
//  
//
//  Created by Steve on 2/24/21.
//

import SwiftUI
import Vision

public struct TextCam<Content>: View where Content: View {
    let builder: ([VNTextObservation]) -> Content
    //@StateObject var vm = TextCamVM()
    
    public init(@ViewBuilder builder: @escaping ([VNFaceObservation]) -> Content) {
        self.builder = builder
    }
    
    var body: some View {
        Text("Hello, TextCam!")
    }
}

struct TextCam: PreviewProvider {
    static var previews: some View {
        TextCam()
    }
}
