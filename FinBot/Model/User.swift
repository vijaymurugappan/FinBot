//
//  User.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 10/7/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit

class User: NSObject {
    @objc var name: String?
    @objc var email: String?
    @objc var januaryE: NSNumber?
    @objc var febrauryE: NSNumber?
    @objc var marchE: NSNumber?
    @objc var aprilE: NSNumber?
    @objc var mayE: NSNumber?
    @objc var juneE: NSNumber?
    @objc var julyE: NSNumber?
    @objc var augustE: NSNumber?
    @objc var septemberE: NSNumber?
    @objc var octoberE: NSNumber?
    @objc var novemberE: NSNumber?
    @objc var decemberE: NSNumber?
    @objc var januaryS: NSNumber?
    @objc var febrauryS: NSNumber?
    @objc var marchS: NSNumber?
    @objc var aprilS: NSNumber?
    @objc var mayS: NSNumber?
    @objc var juneS: NSNumber?
    @objc var julyS: NSNumber?
    @objc var augustS: NSNumber?
    @objc var septemberS: NSNumber?
    @objc var octoberS: NSNumber?
    @objc var novemberS: NSNumber?
    @objc var decemberS: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["text"] as? String
        self.email = dictionary["email"] as? String
        self.januaryE = dictionary["januaryE"] as? NSNumber
        self.febrauryE = dictionary["febrauryE"] as? NSNumber
        self.marchE = dictionary["marchE"] as? NSNumber
        self.aprilE = dictionary["aprilE"] as? NSNumber
        self.mayE = dictionary["mayE"] as? NSNumber
        self.juneE = dictionary["juneE"] as? NSNumber
        self.julyE = dictionary["julyE"] as? NSNumber
        self.augustE = dictionary["augustE"] as? NSNumber
        self.septemberE = dictionary["septemberE"] as? NSNumber
        self.octoberE = dictionary["octoberE"] as? NSNumber
        self.novemberE = dictionary["novemberE"] as? NSNumber
        self.decemberE = dictionary["decemberE"] as? NSNumber
        self.januaryS = dictionary["januaryS"] as? NSNumber
        self.febrauryS = dictionary["febrauryS"] as? NSNumber
        self.marchS = dictionary["marchS"] as? NSNumber
        self.aprilS = dictionary["aprilS"] as? NSNumber
        self.mayS = dictionary["mayS"] as? NSNumber
        self.juneS = dictionary["juneS"] as? NSNumber
        self.julyS = dictionary["julyS"] as? NSNumber
        self.augustS = dictionary["augustS"] as? NSNumber
        self.septemberS = dictionary["septemberS"] as? NSNumber
        self.octoberS = dictionary["octoberS"] as? NSNumber
        self.novemberS = dictionary["novemberS"] as? NSNumber
        self.decemberS = dictionary["decemberS"] as? NSNumber
    }
}
