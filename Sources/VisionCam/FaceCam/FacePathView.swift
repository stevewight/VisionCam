//
//  FacePathView.swift
//  VisionCam
//
//  Created by Steve on 8/27/20.
//

import SwiftUI
import Vision

public struct FacePathView: View {
    let color: Color
    let obs: VNFaceObservation
    
    public init(for obs: VNFaceObservation, color: Color = .blue) {
        self.color = color
        self.obs = obs
    }
    
    private func makePath(points: [[CGPoint]?], isClosed: Bool = false) -> Path {
        return Path { path in
            points.forEach { subPoints in
                if let sp = subPoints, let fp = sp.first {
                    path.move(to: fp)
                    path.addLines(sp)
                    if isClosed {
                        path.addLine(to: fp)
                        path.closeSubpath()
                    }
                }
            }
        }
    }
    
    private func openPoints(_ size: CGSize) -> [[CGPoint]?] {
        obs.openRegions().map { r in
            r?.pointsInImage(imageSize: size)
        }
    }
    
    private func closedPoints(_ size: CGSize) -> [[CGPoint]?] {
        obs.closedRegions().map { r in
            r?.pointsInImage(imageSize: size)
        }
    }
    
    public var body: some View {
        GeometryReader { geo in
            makePath(points: openPoints(geo.size))
                .faceTransform(newY: geo.size.height)
                .stroke(color, lineWidth: 1)
            makePath(points: closedPoints(geo.size), isClosed: true)
                .faceTransform(newY: geo.size.height)
                .stroke(color, lineWidth: 1)
        }
    }
    
}
