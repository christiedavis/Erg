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
    
    init(_ pieceArray: [PieceDTO], _ session: SessionDTO) {
        self.pieceArray = pieceArray
        self.session = session
    }
    
    init(_ pieceArray: [Piece], _ session: Session) {
        self.session = session.asSessionDTO()
        self.pieceArray = pieceArray.map({ $0.asPieceDTO() })
    }
}
