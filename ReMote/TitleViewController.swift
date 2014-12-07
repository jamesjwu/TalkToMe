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
  @IBOutlet var ServerClosedLabel: UILabel!
  @IBOutlet var username: UITextField!
  
  
  
  @IBOutlet var TypeInUsername: UILabel!
  
  
  var serverPort = 0
  var hostname = ""
  var hideServer = true
  override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
  if(identifier == "ConnectToServer") {
      if self.username == nil {
        return false
      }
      if self.username.text == "" {
        self.ServerClosedLabel.hidden = true
        self.TypeInUsername.hidden = false
        return false
      }
    
    }
    return true
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var dest = segue.destinationViewController as ViewController
    dest.username = self.username.text
    dest.connect(UInt32(self.serverPort), serverAddress: self.hostname)
    
    self.TypeInUsername.hidden = true
    self.hideServer = true
  }
  
  override func viewDidLoad() {
    self.ServerClosedLabel.hidden = self.hideServer
  
  }
  
  

}