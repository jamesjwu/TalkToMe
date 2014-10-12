//
//  TitleViewController.swift
//  ReMote
//
//  Created by James Wu on 10/12/14.
//  Copyright (c) 2014 James Wu. All rights reserved.
//

import Foundation
import UIKit

class TitleViewController : UIViewController {
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var dest = segue.destinationViewController as ViewController
    dest.username = self.username.text
    dest.connect()
  }
  
  @IBOutlet var username: UITextField!

}