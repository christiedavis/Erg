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
    var rowId: Int = -1
    var distance: String = ""
    var time: String = ""
    var rate: Int?
    
    init(rowId: Int) {
        self.rowId = rowId
    }
    
    init(rowId: Int, distance: String, time: String, rate: Int) {
        self.rowId = rowId
        self.distance = distance
        self.time = time
        self.rate = rate
    }
}

class Piece {
    var ref: DatabaseReference?
    var distance: String?
    var time: String?
    var rate: Int?
    
    var title: String = "piece" // This is used by the session object
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        distance = data["distance"]! as? String
        time = data["time"]! as? String
        rate = data["rate"] as? Int
    }
    init(_ piece: PieceDTO, sessionType: SessionType) {
        
        self.time = piece.time
        self.distance = piece.distance
        self.rate = piece.rate
        
        if sessionType == .distance {
            title = "piece.distance"
        } else {
            title = "piece.time"
        }
        
        self.ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "distance": distance as Any,
            "time": time as Any,
            "rate": rate as Any
        ]
    }
    
    func asPieceDTO() -> PieceDTO {
        return PieceDTO(rowId: -1, distance: self.distance ?? "", time: self.time ?? "", rate: self.rate ?? 0)
    }
}
