//
//  Workout.swift
//  erg
//
//  Created by Christie Davis on 26/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation

struct WorkoutDTO {
    var pieceArray: [PieceDTO] = []
    var session: SessionDTO = SessionDTO()

    var sessionDBO: Any {
        return Session(session: session).toAnyObject()
    }
    
    var pieces: [Any] {
        return pieceArray.map({ Piece($0, sessionType: session.sessionType)}).map({ $0.toAnyObject() })
    }
}
