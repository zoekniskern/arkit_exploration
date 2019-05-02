//
//  ViewController.swift
//  Kniskern_FinalProj
//
//  Created by Student on 4/18/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    //https://stackoverflow.com/questions/45026702/when-new-view-appears-on-scene-view-app-is-freezed
    
    
    @IBOutlet var sceneView: ARSCNView!
    let sceneManager = ARSceneManager()
    var yourArt: UIImage!
    var object: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        sceneManager.attach(to: sceneView)
        sceneManager.displayDebugInfo()
        
        //handle taps
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScene(_:)))
            view.addGestureRecognizer(tapGesture)

        //handle pinches
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        sceneView.addGestureRecognizer(pinchGesture)
        
        //yourArt = myArt.shared.myImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneManager.resetScene()
        //let configuration = ARWorldTrackingConfiguration()
        //sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    //tap action
    @objc func didTapScene(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            let location = gesture.location(ofTouch: 0, in: sceneView)
        
            let hit = sceneView.hitTest(location, types: .existingPlaneUsingGeometry)
            
            if let hit = hit.first {
                placeBlockOnPlaneAt(hit)
            }
        default:
            break
        }
    }
    
    //pinch action
    //https://www.yudiz.com/the-simple-steps-to-virtual-object-interaction-using-arkit/
    @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
        guard let _ = object else { return }
        var originalScale = object?.scale
        
        switch gesture.state {
        case .began:
            originalScale = object?.scale
            gesture.scale = CGFloat((object?.scale.x)!)
        case .changed:
            guard var newScale = originalScale else { return }
            if gesture.scale < 0.5{ newScale = SCNVector3(x: 0.5, y: 0.5, z: 0.5) }else if gesture.scale > 2{
                newScale = SCNVector3(2, 2, 2)
            }else{
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }
            object?.scale = newScale
        case .ended:
            guard var newScale = originalScale else { return }
            if gesture.scale < 0.5{ newScale = SCNVector3(x: 0.5, y: 0.5, z: 0.5) }else if gesture.scale > 2{
                newScale = SCNVector3(2, 2, 2)
            }else{
                newScale = SCNVector3(gesture.scale, gesture.scale, gesture.scale)
            }
            object?.scale = newScale
            gesture.scale = CGFloat((object?.scale.x)!)
        default:
            gesture.scale = 1.0
            originalScale = nil
        }
    }
    
    
    //place an object
    func placeBlockOnPlaneAt(_ hit: ARHitTestResult) {
        let box = createBox()
        //position(node: box, atHit: hit)
        //box.position = SCNVector3Make(hit.worldTransform.columns.3.x, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
        box.position = SCNVector3Make(hit.worldTransform.columns.3.x, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
        
        //let translationMatrix = SCNMatrix4Translate(box.worldTransform, 0.1, 0.1, 0.1) //tx, ty, tz are translations in each axis i and then theNode.transform = translation matrix
        
        //box.transform = translationMatrix
        
        sceneView?.scene.rootNode.addChildNode(box)
        object = box
    }
    
    private func createBox() -> SCNNode {
        let box = SCNBox(width: 0.15, height: 0.20, length: 0.02, chamferRadius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = myArt.shared.myImage//yourArt
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        
        return boxNode
    }
    
    private func position(node: SCNNode, atHit hit: ARHitTestResult) {
        //node.transform = SCNMatrix4(hit.anchor!.transform)
        node.eulerAngles = SCNVector3Make(node.eulerAngles.x + Float.pi / 2, node.eulerAngles.y, node.eulerAngles.z)
        let position = SCNVector3Make(hit.worldTransform.columns.3.x + node.geometry!.boundingBox.min.z, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
        //let position = SCNVector3Make(hit.worldTransform.columns.3.x, hit.worldTransform.columns.3.y, hit.worldTransform.columns.3.z)
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
}
