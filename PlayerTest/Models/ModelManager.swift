//
//  ModelManager.swift
//  PlayerTest
//
//  Created by Fernanda de Lima on 18/01/2018.
//  Copyright © 2018 Empresinha. All rights reserved.
//

import UIKit

let mm = ModelManager.instance
class ModelManager: NSObject {
    
    //Singleton struct
    static let instance = ModelManager()
    
    //representaçoes das models
    var response: Response?
   
}
