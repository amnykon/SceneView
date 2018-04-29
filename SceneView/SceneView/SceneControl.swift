import Foundation
import SceneKit

public protocol SceneControlDelegate: SCNSceneRendererDelegate {
  func selected(nodeId: String)
  func isNodeSelectable(nodeId: String) -> Bool
}

open class SceneControl: SceneView {
  let tapRecognizer = UITapGestureRecognizer()

  public weak var sceneControlDelegate: SceneControlDelegate?

  init(scene: SCNScene) {
    super.init(scene: scene)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
    tapRecognizer.delegate = self
    addGestureRecognizer(tapRecognizer)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func tapGesture(sender: UITapGestureRecognizer) {
    let point = sender.location(in: self)
    let selectableNode = hitTest(point: point)

    guard let node = selectableNode else {
      return
    }

    if !(selectableNode is SelectableNode) {
        return
    }

    guard let name = node.name else {
        return
    }

    sceneControlDelegate?.selected(nodeId: name )
  }

  func hitTest(point: CGPoint) -> SCNNode? {
    let results = hitTest(point, options: nil)
    for result in results {
      var node = result.node

      while true {
        if let selectableNode = node as? (SelectableNode & SCNNode) {
          if let name = selectableNode.name {
            if sceneControlDelegate?.isNodeSelectable(nodeId: name) ?? true {
              return node
            }
          }
        }

        guard let parentNode = node.parent else {
          break
        }
        node = parentNode
      }
    }
    return nil
  }
}
