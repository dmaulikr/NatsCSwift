//
//  ViewController.swift
//  NatsManagerDemo
//
//  Created by Desai on 01/03/24.
//

import UIKit
import NatsManagerClass

class ViewController: UIViewController {

    var nManager = NatsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filePath = Bundle.main.path(forResource: "seed", ofType: "nk") {
            print(filePath)
            let status = nManager.setNKeyFromSeed(publicKey: "your publicKey", seedContent: filePath, url: "your server URL")
            if status == true {
                print("Connected!")
                
                let strM = "Hello!"
                let strSubject = "events.app"
                let mStatus = nManager.publish(subject: strSubject, message: strM)
                if mStatus {
                    print("NATS Event logged ---- Message -> \(strM)")
                }
                
            }
        } else {
            print("not found")
        }
        
    }


}
