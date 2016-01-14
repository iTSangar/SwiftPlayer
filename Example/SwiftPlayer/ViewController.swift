//
//  ViewController.swift
//  SwiftPlayer
//
//  Created by iTSangar on 01/14/2016.
//  Copyright (c) 2016 iTSangar. All rights reserved.
//

import UIKit
import SwiftPlayer

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    SwiftPlayer.play()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

