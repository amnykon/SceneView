import UIKit
import SceneKit
import IdentifiableSet

open class SceneControlViewController: UIViewController {
  public let sceneControl: SceneControl
  public var sceneControlDelegate: SceneControlDelegate? = nil

  open override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(sceneControl)
    sceneControl.translatesAutoresizingMaskIntoConstraints = false
    sceneControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    sceneControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    sceneControl.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    sceneControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  public init(scene: SCNScene) {
    sceneControl = SceneControl(scene: scene)
    super.init(nibName: nil, bundle: nil)

    sceneControl.sceneControlDelegate = self
    sceneControl.cameraDelegate = SquareCameraDelegate()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SceneControlViewController: SceneControlDelegate {
  public func selected(nodeId: GenericId) {
    sceneControlDelegate?.selected(nodeId: nodeId)
  }

  public func isNodeSelectable(nodeId: GenericId) -> Bool {
    return  sceneControlDelegate?.isNodeSelectable(nodeId: nodeId) ?? true
  }
}
