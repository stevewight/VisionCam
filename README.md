# VisionCam

📸 Easily add computer vision to your SwiftUI app 📸

VisionCam simplifies the process of building SwiftUI camera apps that utilize computer vision.  It handles most of the boilerplate ``AVCaptureSession`` setup and input/output connection as well as UIKit -> SwiftUI integration with ``UIViewControllerRepresentable``.

## Usage

### Face Detection and Tracking

To easily detect and track all faces within the camera feed, use the ``FaceCam`` view.  

You can do this like any other SwiftUI view (i.e. adding to the ``rootViewController`` in the ``SceneDelegate`` class).

The ``FaceCam`` view will provide a ``ViewBuilder`` that passes the face observations as a parameter to the block. 

```swift
    // In the scene(_,session:,connectionOptions:) method within your SceneDelegate class
    // add FaceCam view to the root UIHostingController
    
    //...
    
    let cam = FaceCam { in observations
        if let firstObservation = observations.first {
            FacePathView(for: firstObservation)
        }
    }

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UIHostingController(rootView: cam)
    window.makeKeyAndVisible()
    
    //...
```

The above will use the provided ``FacePathView`` and display it on the first ``VNFaceObservation`` found by the system.

You can create your own custom views for face tracking by using some provided helper extensions on ``VNFaceObservation`` and ``Path``.

```swift
    //...

    let cam = FaceCam { observations in
        GeometryReader { geo in
            if let obs = observations.first,
               let rect = obs.boxRect(size: geo.size) {
                Rectangle()
                    .path(in: rect)
                    .faceTransform(newY: geo.size.height)
                    .stroke(Color.red)
            }
        }
    }
    
    //...
```

In the above example, once we unwrap our first observation, the ``.boxRect(size:)`` method (provided by **VisionCam**) projects our view from the normalized to the image coordinate space and returns the proper face observation ``CGRect``.

**Note:** we are using the ``GeometryReader`` to get the parent views size for projecting the coordinate space change.

The call to ``faceTransform(newY:)`` is also important as it translates and scales the view rect to the proper size/position in the preview space.

## Installation

### Swift Package Manager (SPM)

The Swift Package Manager can be used to install VisionCam.

Follow the instructions for [adding package dependencies](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) provided in the Apple documentation.

Alternatively if you already have your ``Package.swift`` set up, you could add a value for VisionCam to your ``dependencies`` array:

```swift
    //...

    dependencies: [
        .package(
            url: "https://github.com/stevewight/VisionCam.git"
            from: "0.0.1"
        )
    ]

    //...
```

## Road Map
- [x] Face detection and tracking
- [ ] Pose detection and tracking
- [ ] Custom model detection and tracking (with CoreML)

## License
VisionCam is released under the ***MIT*** license. See LICENSE for details.
