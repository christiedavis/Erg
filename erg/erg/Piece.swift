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
    var distance: Int!
    var time: Int!
    var rate: Int?
}

class Piece {
    var ref: DatabaseReference?
    var distance: Int?
    var time: Int?
    var rate: Int?
    
    var title: String = "piece" // This is used by the session object
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        distance = data["distance"]! as? Int
        time = data["time"]! as? Int
        rate = data["rate"]! as? Int
    }
    init(_ piece: PieceDTO, sessionType: SessionType) {
        
        self.time = piece.time
        self.distance = piece.distance
        self.rate = piece.rate
        
        if sessionType == .distance {
            title = "\(piece.distance)"
        } else {
            title = "\(piece.time)"
        }
        
        self.ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "distance": distance,
            "time": time,
            "rate": rate
        ]
    }
    
    func asPieceDTO() -> PieceDTO {
        return PieceDTO(distance: self.distance, time: self.time, rate: self.rate)
    }
}
