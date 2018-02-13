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
    var sessionType: SessionType = .time
//    var distance: Int?
//    var time: Int?
    var value: Int?
//    var rate: Int?
    var date: Date = Date()
    var pieces: Dictionary<Int, PieceDTO>?
}

class Session {
    
    var ref: DatabaseReference?
    var title: String?
    var type: Int?
//    var distance: Int?
//    var time: Int?
    var value: Int?
//    var rate: Int?
    var date: Date? // TODO: do i need this?
    var pieces: Dictionary<Int, Piece>?
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
//           + NSDictionary
//           * + NSArray
//           * + NSNumber (also includes booleans)
//           * + NSString
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        title = data["title"]! as? String
        type = data["type"]! as? Int
//        distance = data["distance"]! as? Int
//        time = data["time"]! as? Int
        value = data["value"]! as? Int
        date = data["date"]! as? Date
        pieces = data["pieces"]! as? Dictionary<Int, Piece>
    }
    
    init(session: SessionDTO) {
       
        pieces = session.pieces?.flatMap({ sessionPiece -> (Int, Piece) in
            return (sessionPiece.key, Piece(sessionPiece.value, date: session.date, sessionType: session.sessionType))
        }).toDictionary()
        type = session.sessionType.rawValue
        date = session.date
        title = session.title ?? "No pieces"
        
        self.ref = nil
        
    }
    
    func toAnyObject() -> Any {
        return [
//            "distance": distance,
//            "time": time,
            ]
    }
}

