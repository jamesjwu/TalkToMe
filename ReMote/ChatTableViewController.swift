//
//  ChatTableViewController.swift
//  TalkToMe
//
//  Created by James Wu on 11/20/14.
//  Copyright (c) 2014 James Wu. All rights reserved.
//

import Foundation
import UIKit

struct Server {
  var description: String
  var hostname : String
  var port : Int
}


protocol ServerProtocol {
  func addNewServer(description: String, hostname: String, port: Int)
}

class ChatTableViewController: UITableViewController, UITableViewDataSource, ServerProtocol  {
  var servers : [Server] = [Server(description: "Default", hostname:"localhost", port:1112)]
  
  override func viewDidLoad() {
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 137.0/255.0, green:207.0/255.0, blue:240.0/255.0, alpha: 1.0)
    self.tableView.tintColor = UIColor(red: 137.0/255.0, green:207.0/255.0, blue:240.0/255.0, alpha: 1.0)
    
    self.tableView.backgroundColor = UIColor(red: 137.0/255.0, green:207.0/255.0, blue:240.0/255.0, alpha: 1.0)
    

  }
  
  
  func addNewServer(description: String, hostname: String, port: Int) {
    self.servers.append(Server(description: description, hostname: hostname, port: port))
    self.tableView.reloadData()
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.servers.count
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    switch segue.identifier! {
    case "server":
      if var secondViewController = segue.destinationViewController as? TitleViewController {
        if var cell = sender as? ChatTableViewCell {
          secondViewController.serverPort = cell.portLabel.text!.toInt()!
          secondViewController.hostname = cell.hostLabel.text!
          println(secondViewController.serverPort)
          println(secondViewController.hostname)
        }
      }
    case "add":
      if var secondViewController = segue.destinationViewController as? NewServerViewController {
        secondViewController.delegate = self
      }
      
      
    
    default:
      break
    }

  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("server") as? ChatTableViewCell ?? ChatTableViewCell()
    var server: Server = servers[indexPath.row] as Server
    cell.titleLabel.text = server.description
    cell.hostLabel.text = server.hostname
    cell.portLabel.text = String(server.port)
    
    var bgColorView = UIView()
    bgColorView.backgroundColor = UIColor(red: 0/255.0, green:255/255.0, blue: 255/255.0, alpha: 1.0)
    cell.selectedBackgroundView = bgColorView

    
    return cell
  }


}