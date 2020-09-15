# VisionCam

📸 Easily add computer vision to your SwiftUI app 📸

VisionCam simplifies the process of building SwiftUI camera apps that utilize computer vision.  It handles most of the boilerplate ``AVCaptureSession`` setup and input/output connection as well as UIKit -> SwiftUI integration with ``UIViewControllerRepresentable``.  Take a deeper look at the architecture below for a high level view of how the system is built or jump straight to the usage and see how easy it is to use in your app.

## Architecture

**TODO**

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

In the above example, once we unwrap our first observation, the ``.boxRect(size:)`` method (provided by **VisionCam**) projects our view from the normalized to the image coordinate space and returns the proper face observation ``CGRect``.  Note we are using the ``GeometryReader`` to get the parent views size for projecting the coordinate space change.  The call to ``faceTransform(newY:)`` is also important as it translates and scales the view rect to the proper size/position in the preview space.

## Installation

## Road Map

## License
