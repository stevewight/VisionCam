//
//  FacePathView.swift
//  VisionCam
//
//  Created by Steve on 8/27/20.
//

import SwiftUI
import Vision

/**
 Basic view for use with displaying a face observation
 */
public struct FacePathView: View {
    let color: Color
    let obs: VNFaceObservation
    
    /**
     Custom view initializer for displaying a face observation

     - Parameters:
        - obs: Observation to draw view around
        - color: Color of the view path
     */
    public init(for obs: VNFaceObservation, color: Color = .blue) {
        self.color = color
        self.obs = obs
    }
    
    /**
     Helper for making path around given points

     - Parameters:
        - points: An array of CGPoint arrays that represent where the path should be drawn
        - isClosed: If the final point should be connected to the initial point
     */
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
    
    /**
     The open points from the landmark regions

     - Parameter size: The size of the image to get points from
     - Returns: Array of all landmark point arrays in the given image coordinate space
     */
    private func openPoints(_ size: CGSize) -> [[CGPoint]?] {
        obs.openRegions().map { r in
            r?.pointsInImage(imageSize: size)
        }
    }
    
    /**
     The closed points from the landmark regions

     - Parameter size: The size of the image to get points from
     - Returns: Array of all landmark point arrays in the given image coordinate space
     */
    private func closedPoints(_ size: CGSize) -> [[CGPoint]?] {
        obs.closedRegions().map { r in
            r?.pointsInImage(imageSize: size)
        }
    }
    
    /**
     Body of the view

     The `GeometryReader` is used to access the parent views size which is leveraged to draw the necessary paths.  The `faceTransform` `Path` method is used to scale and translate to the required Vision coordinate space.
     */
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
