//
//  Session.swift
//  erg
//
//  Created by Christie Davis on 9/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct SessionDTO {
    var title: String?
    var type: Int?
    var distance: Int?
    var time: Int?
    var rate: Int?
    var date: Date?
    var pieces: Dictionary<Int, PieceDTO>?
}

class Session {
    
    var ref: DatabaseReference
    var title: String?
    var type: Int?
    var distance: Int?
    var time: Int?
    var rate: Int?
    var date: Date?
    var pieces: Dictionary<Int, Piece>?
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
//            + NSDictionary
//            * + NSArray
//            * + NSNumber (also includes booleans)
//            * + NSString
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        title = data["title"]! as? String
        type = data["type"]! as? Int
        distance = data["distance"]! as? Int
        time = data["time"]! as? Int
        rate = data["rate"]! as? Int
        date = data["date"]! as? Date
        pieces = data["pieces"]! as? Dictionary<Int, Piece>
    }
}


