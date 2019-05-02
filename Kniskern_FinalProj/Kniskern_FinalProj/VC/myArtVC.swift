//
//  myArtVC.swift
//  Kniskern_FinalProj
//
//  Created by Student on 4/22/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class myArtVC: UIViewController {

    @IBOutlet weak var customView: CustomView!
    var yourArt: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yourArt = myArt.shared.myImage
        customView.backgroundColor = UIColor.white
        
        myArt.shared.myImage = customView.takeScreenshot()
        // Do any additional setup after loading the view.
    }
    
    //func takeScreenshot(){
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        
        //myArt.shared.myImage = image
        
        //print("image was updated")
    //}
    
    @IBAction func cls(sender: AnyObject){
        customView.cls()
    }
    
    @IBAction func undo(sender: AnyObject){
        customView.undo()
    }
    
    //screenshot
    @IBAction func buttonScreenshot(_ sender: Any) {
        myArt.shared.myImage = customView.takeScreenshot()
    }
    
    @IBAction func setCanvasColor(sender:AnyObject){
        switch sender.tag{
        case 1:
            customView.backgroundColor = UIColor.white
            break
        case 2:
            customView.backgroundColor = UIColor.yellow
            break
        default:
            customView.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func share(sender:AnyObject){
        let image = myArt.shared.myImage
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(activity, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
