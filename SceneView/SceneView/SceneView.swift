import UIKit
import SceneKit

open class SceneView: FixedSceneView {
  var cameraDelegate: CameraDelegate?


  init(scene: SCNScene, cameraDelegate: CameraDelegate = SquareCameraDelegate()) {
    self.cameraDelegate = cameraDelegate
    super.init(scene: scene)

    let panRecognizer = UIPanGestureRecognizer()
    panRecognizer.addTarget(self, action: #selector(panGesture))
    panRecognizer.delegate = self
    addGestureRecognizer(panRecognizer)

    let rotationGestureRecognizer = UIRotationGestureRecognizer()
    rotationGestureRecognizer.addTarget(self, action: #selector(rotationGesture))
    rotationGestureRecognizer.delegate = self
    addGestureRecognizer(rotationGestureRecognizer)

    let pinchGestureRecognizer = UIPinchGestureRecognizer()
    pinchGestureRecognizer.addTarget(self, action: #selector(pinchGesture))
    pinchGestureRecognizer.delegate = self
    addGestureRecognizer(pinchGestureRecognizer)

    updateCamera()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func updateCamera() {
    if let cameraDelegate = cameraDelegate {
      camera.transform = cameraDelegate.getTransform()
      camera.set(fieldOfView: cameraDelegate.getfieldOfView())
    }
  }

  private var panDx: CGFloat = 0
  private var panDy: CGFloat = 0
  @objc func panGesture(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    cameraDelegate?.pan(
      dx: translation.x - panDx,
      dy: translation.y - panDy,
      touchCount: UInt(sender.numberOfTouches)
    )

    if sender.state == .ended {
      panDx = 0
      panDy = 0
    } else {
      panDx = translation.x
      panDy = translation.y
    }

    updateCamera()
  }

  private var rotationD: CGFloat = 0.0
  @objc func rotationGesture(sender: UIRotationGestureRecognizer) {
    cameraDelegate?.rotate(by:sender.rotation - rotationD)

    if sender.state == .ended {
      rotationD = 0.0
    } else {
      rotationD = sender.rotation
    }

    updateCamera()
  }

  private var zoomD: CGFloat = 1.0
  @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
    cameraDelegate?.zoom(by: sender.scale / zoomD)

    if sender.state == .ended {
      zoomD = 1.0
    } else {
      zoomD = sender.scale
    }

    updateCamera()
  }
}

extension SceneView: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return !(gestureRecognizer is UIPanGestureRecognizer) && !(otherGestureRecognizer is UIPanGestureRecognizer)
  }
}

