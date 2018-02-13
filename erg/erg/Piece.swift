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
    var ref: DatabaseReference?
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
    init(_ piece: PieceDTO, date: Date, sessionType: SessionType) {
        
//        var things = session.pieces?.map({ (key: Int, value: PieceDTO) -> (key: Int, value: Piece) in
//            var newThing = (key, Piece(value, session.date, session.sessionType))
//        })
//        
//        title = "\(pieces)x \(value)"
//        
        
        self.ref = nil
        
    }
    
    func toAnyObject() -> Any {
        return [
            "distance": distance,
            "time": time,
        ]
    }
}
