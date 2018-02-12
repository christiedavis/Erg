//
//  Piece.swift
//  erg
//
//  Created by Christie on 13/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PieceDTO {
    var distance: Int?
    var time: Int?
    var rate: Int?
}

class Piece {
    var ref: DatabaseReference
    var distance: Int?
    var time: Int?
    var rate: Int?
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        distance = data["distance"]! as? Int
        time = data["time"]! as? Int
        rate = data["rate"]! as? Int
    }
}
