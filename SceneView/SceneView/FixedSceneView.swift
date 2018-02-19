import UIKit
import SceneKit

open class FixedSceneView: SCNView {
  let camera: Camera

  public init(scene: SCNScene) {
    self.camera = Camera(transform: SCNMatrix4Identity, fieldOfView: 15.0)
    super.init(frame: CGRect(), options: nil)

    self.scene = scene

    scene.rootNode.addChildNode(camera)

    self.pointOfView = camera
    backgroundColor = UIColor.clear
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    camera.removeFromParentNode()
  }
}

