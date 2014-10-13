//
//  ViewController.swift
//  ReMote
//
//  Created by James Wu on 10/12/14.
//  Copyright (c) 2014 James Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSStreamDelegate, UITextViewDelegate
{

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

  }
  
  //change the server Address to actual address if deploying
  let serverAddress: CFString = "localhost"
  // arbitrary server port
  let serverPort: UInt32 = 1112
  var input : NSInputStream?
  var output : NSOutputStream?
  var messages : NSMutableString = ""
  var serverHadError  = false

  @IBOutlet var messageText: UITextView!

  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    if textView == self.messageText {
      return false
    }
    return true
  }
  

  
  func connect() {
    var readStream:  Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    //connect to the host
    CFStreamCreatePairWithSocketToHost(nil, self.serverAddress, self.serverPort, &readStream, &writeStream)
    
    self.input = readStream!.takeRetainedValue()
    self.output = writeStream!.takeRetainedValue()
    
    self.input!.delegate = self
    self.output!.delegate = self
    
    
    self.input!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    self.output!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    
    //open the connections!
    self.input!.open()
    self.output!.open()
    
    //send confirmation to server that you've logged on.
    var loginString : NSMutableString = "usr>"
    loginString.appendString(self.username)
    var rawString = loginString.dataUsingEncoding(NSASCIIStringEncoding)
    self.output!.write(UnsafePointer<UInt8>(rawString!.bytes), maxLength: loginString.length)

  }
  
  //asynchronous event processing
  func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
    switch(eventCode) {
    case NSStreamEvent.OpenCompleted:
      break
  
    //Information is available to pick up from server
    case NSStreamEvent.HasBytesAvailable:
      if aStream == self.input {
        while self.input!.hasBytesAvailable {
          let bufferSize = 1024
          var buffer = Array<UInt8>(count: bufferSize, repeatedValue: 0)
          
          let bytesRead = self.input!.read(&buffer, maxLength: bufferSize)
          if bytesRead >= 0 {
            var output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding)
            self.messages.appendString(output)
            self.messageText.text = self.messages
            
            
          }
        }
      }
      break
    
    case NSStreamEvent.HasSpaceAvailable:
      break
      
    case NSStreamEvent.ErrorOccurred:
      self.serverHadError = true
      break
    
    case NSStreamEvent.EndEncountered:
      self.serverHadError = true
      performSegueWithIdentifier("BackToConnection", sender: self)
      
      break
    
    default:
      break
      
    }
    
  }
  override func viewDidAppear(animated: Bool) {
    if(self.serverHadError) {
      performSegueWithIdentifier("BackToConnection", sender: self)
    }
    
  
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  


  }

  var username : NSString = ""
  @IBOutlet var message: UITextField!
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var dest = segue.destinationViewController as TitleViewController
    
    dest.hideServer = !self.serverHadError
    
    self.input!.close()
    self.output!.close()
  }
  
  


  @IBAction func sendMessage(sender: AnyObject) {

    var messageString : NSMutableString = "msg>"
    messageString.appendString(self.message.text)
    var rawString : NSData = messageString.dataUsingEncoding(NSASCIIStringEncoding)!
    
    self.output!.write(UnsafePointer<UInt8>(rawString.bytes), maxLength: messageString.length)
    self.message.text = ""
    
    
  }
}

