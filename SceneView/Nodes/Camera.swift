import Foundation
import SceneKit

class Camera: SCNNode {
  init(transform: SCNMatrix4 = SCNMatrix4Identity, fieldOfView: CGFloat) {
    super.init()

    camera = SCNCamera()

    self.transform = transform
    set(fieldOfView: fieldOfView)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(fieldOfView: CGFloat) {
    camera?.fieldOfView = fieldOfView
  }
}
