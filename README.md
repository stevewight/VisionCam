# VisionCam

📸 Easily add computer vision to your SwiftUI app 📸

VisionCam simplifies the process of building SwiftUI camera apps that utilize computer vision.  It handles most of the boilerplate ``AVCaptureSession`` setup and input/output connection as well as UIKit -> SwiftUI integration with ``UIViewControllerRepresentable``.  Take a deeper look at the architecture below for a high level view of how the system is built or jump straight to the usage and see how easy it is to use in your app.

## Architecture

**TODO**

## Usage

### Face Detection and Tracking

To easily detect and track all faces within the camera feed, use the ``FaceCam`` view.  

You can do this like any other SwiftUI view (i.e. adding to the ``rootViewController`` in the ``SceneDelegate`` class)

```swift
    // In the scene(_,session:,connectionOptions:) method within your SceneDelegate class
    // add FaceCam() to the root UIHostingController
    
    //...
    
    let cam = FaceCam()

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = UIHostingController(rootView: FaceCam())
    window.makeKeyAndVisible()
    
    //...
```

The above will use the default ``FaceMaskView``  to automatically track the observations.  You can easily add your own views to track the detected observations by passing in the view via ``ViewBuilder``.

```swift
    //...

    let cam = FaceCam { observations in
        MyCustomFaceMaskView()
    }
    
    //...
```


## Installation

## Road Map

## License
