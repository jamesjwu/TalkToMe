//
//  NewServerViewController.swift
//  ReMote
//
//  Created by James Wu on 11/21/14.
//  Copyright (c) 2014 James Wu. All rights reserved.
//


import Foundation
import UIKit



class NewServerViewController : UIViewController {
  @IBOutlet var Description: UITextField!

  @IBOutlet var portLabel: UITextField!
  @IBOutlet var hostLabel: UITextField!
  
  var delegate : ServerProtocol!
  
  @IBAction func ServerAdded(sender: UIButton) {
    self.view.endEditing(true)
    self.delegate.addNewServer(Description.text, hostname: hostLabel.text, port: portLabel.text.toInt()!)
    self.navigationController?.popViewControllerAnimated(true)
  }
  
}