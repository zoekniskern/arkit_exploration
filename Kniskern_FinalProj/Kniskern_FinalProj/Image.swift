//
//  Image.swift
//  Kniskern_FinalProj
//
//  Created by Student on 4/22/19.
//  Copyright © 2019 Student. All rights reserved.
//

import Foundation
import UIKit

class myArt {
    static let shared = myArt()
    var myImage: UIImage?
    
    private init(){
        print("created shared art")
    }
}
