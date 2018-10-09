//
//  Message.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 10/3/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    @objc var text: String?
    @objc var sender: NSNumber?
    @objc var imageURL: String?
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
    @objc var videoURL: String?
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String
        self.sender = dictionary["sender"] as? NSNumber
        self.imageURL = dictionary["imageURL"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.videoURL = dictionary["videoURL"] as? String
    }
}
