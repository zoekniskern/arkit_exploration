//
//  myArtVC.swift
//  Kniskern_FinalProj
//
//  Created by Student on 4/22/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class myArtVC: UIViewController {

    var yourArt: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        yourArt = myArt.shared.myImage
        
        takeScreenshot()
        // Do any additional setup after loading the view.
    }
    
    func takeScreenshot(){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        myArt.shared.myImage = image
        
        print("image was updated")
    }
    
    //screenshot
    @IBAction func buttonScreenshot(_ sender: Any) {
        takeScreenshot()
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
