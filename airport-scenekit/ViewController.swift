//
//  ViewController.swift
//  airport-scenekit
//
//  Created by Gatien DIDRY on 28/10/2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        let rotationNode = scene.rootNode.childNode(withName: "RotationNode", recursively: true)!
        
        let shipMesh : SCNNode = scene.rootNode.childNode(withName: "shipMesh", recursively: true)!
        
        
        self.rotate(node: rotationNode)
        
        let gesture = MyTapeGesture(target: self, action:  #selector(self.landing(sender:)), rotationNode: rotationNode, shipMesh: shipMesh, rootNode : scene.rootNode)
        
        
        sceneView.addGestureRecognizer(gesture)
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    func rotate(node: SCNNode){
        let rotation = SCNAction.rotateBy(x: 0, y: 4 , z: 0, duration: 3)
        let rotationInfinity =  SCNAction.repeatForever(rotation)
        node.runAction(rotationInfinity, forKey: "rotatePlan")
    }
    
    
    @objc func landing(sender : MyTapeGesture){
        sender.rotationNode.removeAction(forKey: "rotatePlan")
        
        
        
        let moveValue = (Float(2 * Double.pi) + Float(Double.pi)/2) - sender.rotationNode.eulerAngles.y.truncatingRemainder(dividingBy: 2 * Float(Double.pi))
        
            sender.rotationNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat(moveValue), z: 0, duration: 3  )){
            
                sender.shipMesh.runAction(SCNAction.rotateBy(x: 0, y: -0.5 * Double.pi, z:  0.15 * Double.pi, duration: 1)){
                    
                    sender.rotationNode.runAction(SCNAction.move(by: SCNVector3( 0, -3.5 , 8), duration: 3))
                    
                    sender.shipMesh.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -0.4 * Double.pi, duration: 3)){
                        
                        sender.rotationNode.runAction(SCNAction.move(by: SCNVector3(0,0,2), duration: 3))
                    }
                }
                
            }
        
    }
}


class MyTapeGesture : UITapGestureRecognizer{
    
    
    var rotationNode : SCNNode
    var shipMesh : SCNNode
    var rootNode : SCNNode
    
    init(target: Any?, action: Selector?, rotationNode : SCNNode, shipMesh : SCNNode, rootNode : SCNNode) {
        self.rotationNode = rotationNode
        self.shipMesh = shipMesh
        self.rootNode = rootNode
        super.init(target: target, action: action)
        
    }
    
    
    
    
    
}
