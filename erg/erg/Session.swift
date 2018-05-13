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
    var id: String?
    var title: String?
    var sessionType: SessionType = .time
    var date: Date?
//    var pieces: [PieceDTO] = []
//    var anyPieces: Any?
}

class Session {
    
    var ref: DatabaseReference?
    var title: String = ""
    var type: Int = 1
    var date: String?     // TODO: do i need this?
    var id: String?
//    var dateOfErg: Date?     // TODO: do i need this?

    
    init (snapshot: DataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, AnyObject>
        title = data["title"] as? String ?? ""
        type = data["type"] as? Int ?? 9
        date = data["date"] as? String
//        dateOfErg = data["dateOfErg"] as? Date

        id = snapshot.key
    }
    
    init(session: SessionDTO) {

        type = session.sessionType.rawValue
        date = session.date?.asDatabaseString()
        title = session.title ?? "NO TITLE"
//        dateOfErg = session.date

        self.ref = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "type": type,
            "date": date,
//            "dateOfErg": dateOfErg
            ]
    }
    
    func asSessionDTO() -> SessionDTO {
        
        print(date?.databaseStringToDate())
        return SessionDTO(id: id, title: title, sessionType: SessionType(rawValue: type) ?? .time, date: date?.databaseStringToDate())
    }
}

