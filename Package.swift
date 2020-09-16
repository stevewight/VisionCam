// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VisionCam",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "VisionCam",
            targets: ["VisionCam"]
        ),
    ],
    targets: [
        .target(
            name: "VisionCam",
            dependencies: []),
        .testTarget(
            name: "VisionCamTests",
            dependencies: ["VisionCam"]),
    ]
)
