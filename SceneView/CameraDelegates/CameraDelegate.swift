import Foundation
import SceneKit

public protocol CameraDelegate {
  func pan(dx: CGFloat, dy: CGFloat, touchCount: UInt)
  func rotate(by rotation: CGFloat)
  func zoom(by scale: CGFloat)

  func getTransform() -> SCNMatrix4
  func getfieldOfView() -> CGFloat
}
