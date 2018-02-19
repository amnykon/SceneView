import Foundation
import SceneKit

public class SquareCameraDelegate: CameraDelegate {

  let locationXSpeed: CGFloat = 0.05
  let locationYSpeed: CGFloat = 0.05

  let maxLocationX: CGFloat = 10.0
  let minLocationX: CGFloat = 0.0
  var locationX: CGFloat = 0.0 {
    didSet {
      locationX = max(minLocationX, min(locationX, maxLocationX))
    }
  }

  let maxLocationZ: CGFloat = 10.0
  let minLocationZ: CGFloat = 0.0
  var locationZ: CGFloat = 0.0 {
    didSet {
      locationZ = max(minLocationZ, min(locationZ, maxLocationZ))
    }
  }

  let angleXSpeed: CGFloat = 1.0
  var angleX: CGFloat = CGFloat.pi * 0.25 {
    didSet {
      angleX = angleX.remainder(dividingBy: CGFloat.pi * 2)
    }
  }

  let angleYSpeed: CGFloat = 0.5
  let maxAngleY: CGFloat = CGFloat.pi * 0.4
  let minAngleY: CGFloat = CGFloat.pi * 0.1
  var angleY: CGFloat = CGFloat.pi * 0.3 {
    didSet {
      angleY = max(minAngleY, min(angleY, maxAngleY))
    }
  }

  public func pan(dx: CGFloat, dy: CGFloat, touchCount: UInt) {
    switch touchCount {
      case 1:
        let xTranslation = dx * locationXSpeed * fieldOfView / 50
        let yTranslation = dy * locationYSpeed * fieldOfView / 50 / sin(angleY)

        locationX += -cos(angleX) * xTranslation + sin(angleX) * yTranslation
        locationZ += -sin(angleX) * xTranslation - cos(angleX) * yTranslation
      case 2:
        angleX += dx * CGFloat.pi / 180.0 * angleXSpeed
        angleY += dy * CGFloat.pi / 180.0 * angleYSpeed
      default:
        break
    }
  }

  public func rotate(by rotation: CGFloat) {
    angleX -= rotation
  }

  let maxFieldOfView: CGFloat = 50.0
  let minFieldOfView: CGFloat = 15.0
  private var fieldOfView: CGFloat = 15.0 {
    didSet {
      fieldOfView = max(minFieldOfView, min(fieldOfView, maxFieldOfView))
    }
  }
  public func zoom(by scale: CGFloat) {
      fieldOfView = fieldOfView / scale
  }

  public func getTransform() -> SCNMatrix4 {
    var transform = SCNMatrix4Identity
    transform = SCNMatrix4Translate(transform, 0.0, 0.0, 25.0)
    transform = SCNMatrix4Rotate(transform, Float(angleY), -1, 0, 0)
    transform = SCNMatrix4Rotate(transform, Float(angleX), 0, -1, 0)
    transform = SCNMatrix4Translate(transform, Float(locationX), 0.0, Float(locationZ))
    return transform
  }

  public func getfieldOfView() -> CGFloat {
    return fieldOfView
  }
}
