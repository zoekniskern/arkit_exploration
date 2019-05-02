//
//  ARSceneManager.swift
//  Kniskern_FinalProj
//
//  Created by Student on 4/22/19.
//  Copyright © 2019 Student. All rights reserved.
//

import ARKit

import Foundation
class ARSceneManager: NSObject {
    var sceneView: ARSCNView?
    private var planes = [UUID: Plane]()
    
    func attach(to sceneView: ARSCNView) {
        self.sceneView = sceneView
        
        self.sceneView!.delegate = self as? ARSCNViewDelegate
        self.sceneView?.autoenablesDefaultLighting = true
        configureSceneView(self.sceneView!)
    }
    
    func displayDebugInfo(){
        sceneView?.showsStatistics = true
        sceneView?.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func resetScene(){
        configureSceneView(self.sceneView!)
    }
    
    private func configureSceneView(_ sceneView: ARSCNView) {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //vertical plane detection enabling
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

extension ARSceneManager: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor  else {return}
        
        //print("Found plane: \(planeAnchor)")
        let plane = Plane(anchor: planeAnchor)
        
        planes[anchor.identifier] = plane
        
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        if let plane = planes[planeAnchor.identifier] {
            plane.updateWith(anchor: planeAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        planes.removeValue(forKey: anchor.identifier)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
//        let sphere = SCNNode()
//        sphere.geometry = SCNSphere(radius: 0.0025)
//        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//    }

}

