//
//  NatsManager.swift
//  NatsManager
//
//  Created by Desai on 29/02/24.
//

import Foundation

public class NatsManager {
    
    public static let shared = NatsManager()
    
    private var optionsPtr: OpaquePointer?
    private var connectionPtr: OpaquePointer?

    public init() {
        var tempOptionsPtr: OpaquePointer? = nil
        let status = natsOptions_Create(&tempOptionsPtr)

        if status == NATS_OK {
            optionsPtr = tempOptionsPtr
        } else {
            // Handle error (log, throw an exception, etc.)
        }
    }

    deinit {
         natsConnection_Destroy(connectionPtr)
         natsOptions_Destroy(optionsPtr)
    }

    public func setNKeyFromSeed(publicKey: String, seedContent: String, url: String) -> Bool {
        do {
            let status = seedContent.withCString { seedCString in
                natsOptions_SetNKeyFromSeed(optionsPtr, publicKey, seedCString)
            }
            
            if status == NATS_OK {
                natsOptions_SetURL(optionsPtr, url)
                var conn: OpaquePointer? = nil
                let connectStatus = natsConnection_Connect(&conn, optionsPtr)
                
//                if connectStatus == NATS_OK {
//                    connectionPtr = conn
//                    // Attempt to publish a message
//                    let publishStatus = self.publish(subject: "events.app", message: "girish_mayank_maulik")
//                    if publishStatus == NATS_OK {
//                        print("Message published successfully.")
//                    } else {
//                        print("Failed to publish message.")
//                    }
//                } else {
//                    // Handle connection error
//                }
                
                return connectStatus == NATS_OK ? true : false
            } else {
                // Handle error setting NKey
                return status == NATS_OK ? true : false
            }
        } catch {
            // Handle file read error
            return false
        }
    }
    
    public func publish(subject: String, message: String) -> Bool {
        guard let connectionPtr = connectionPtr else { return false }
        
        let status = natsConnection_PublishString(connectionPtr, subject, message)
        return status == NATS_OK ? true : false
    }

}
