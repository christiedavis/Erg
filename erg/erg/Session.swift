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
    var date: Date = Date()
//    var pieces: [PieceDTO] = []
//    var anyPieces: Any?
}

class Session {
    
    var ref: DatabaseReference?
    var title: String = ""
    var type: Int = 1
    var date: String?     // TODO: do i need this?
//    var pieces: [Piece] = []
//    var anyPieces: Any?
    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        title = data["title"] as? String ?? ""
        type = data["type"] as? Int ?? 9
        date = data["date"] as? String
//        pieces = data["pieces"] as? [Piece] ?? []
//        anyPieces = data["pieces.*"] as? [Any] ?? []
    }
    
    init(session: SessionDTO) {
       
//        pieces = session.pieces.flatMap({ sessionPiece -> (Piece) in
//            return Piece(sessionPiece, sessionType: session.sessionType)
//        })
        type = session.sessionType.rawValue
        date = "\(session.date)"
//        if pieces.count == 1 {
//            title = pieces.first?.title ?? ""
//        } else {
//            if let firstPiece = pieces.first {
//                title = firstPiece.title
//            }
//        }
        
        self.ref = nil
    }
    
    func toAnyObject() -> Any {
//        let pieceDict =  pieces.map({ $0.toAnyObject() })
        return [
            "title": title,
            "type": type,
            "date": date,
//            "pieces": pieceDict,
            ]
    }
    
    func asSessionDTO() -> SessionDTO {
        return SessionDTO(title: title, sessionType: SessionType(rawValue: type) ?? .time, date: Date())
        //, pieces: pieces.map({ $0.asPieceDTO() }), anyPieces: anyPieces )
    }
}

