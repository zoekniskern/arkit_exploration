//
//  CustomView.swift
//  Simple Draw
//
//  Created by Student on 4/7/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class CustomView: UIView {

    var layers = NSMutableArray()
    var layerIndex = -1
    
    override func draw(_ rect: CGRect) {
        guard layers.count>0 else{
            return
        }
        // Drawing code
        // Get pointer to view
        if let ctx = UIGraphicsGetCurrentContext(){
            //loop through layers
            for points in layers{
                //black stroke
                ctx.setStrokeColor(red:0, green:0, blue:0, alpha:1)
                ctx.setLineWidth(3)
                ctx.setLineJoin(.round)
                ctx.setLineCap(.round)
                
                //loop through layer's point values
                let points = points as! NSMutableArray
                guard points.count >= 2 else{
                    continue
                }
                
                let startPoint = points[0] as! CGPoint
                ctx.move(to: startPoint)
                for i in (1..<points.count-1){
                    let point = points[i] as! CGPoint
                    ctx.addLine(to: point)
                }//end inner for loop
                
                //stroke current layer
                ctx.strokePath()
            }//end outerloop
        }//end if let
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            layerIndex = layerIndex + 1
            // get the CGPoint in the touch
            let pt = touch.location(in: self)
            //new array of points aka layer
            //add points until the user lifts finger
            let points = NSMutableArray()
            //add current point to the layer
            points.add(pt)
            //add layer to layers ivar
            layers.add(points)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch and CGPoint location
        let touch : UITouch! = touches.first
        let pt = touch.location(in: self)
        //grab the array layer from touchesBegan()
        let points = layers[layerIndex] as! NSMutableArray
        //add point to it
        points.add(pt)
        //tell the system
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setNeedsDisplay()
        let points = layers[layerIndex] as! NSMutableArray
        print("ALL DONE - layer=\(layerIndex) points=\(points)")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event!)
    }
    
    //MARK: - Methods -
    func cls(){
        layerIndex = -1
        layers.removeAllObjects()
        setNeedsDisplay()
    }
    
    func undo(){
        if layers.count > 0{
            layers.removeLastObject()
            layerIndex -= 1
            setNeedsDisplay()
        }
    }

}

extension CustomView{
    func takeScreenshot()-> UIImage{
        //        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        //        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //        let image = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        print("image was updated")
        
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image {
            (context) in self.layer.render(in: context.cgContext)
        }
        
        //myArt.shared.myImage = image
        //return image
        
        
    }
}
