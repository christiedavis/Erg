//
//  ArrayExtension.swift
//  erg
//
//  Created by Christie on 13/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

extension Array {
    func toDictionary<K,V>() -> [K:V] where Iterator.Element == (K,V) {
        return self.reduce([:]) {
            var dict:[K:V] = $0
            dict[$1.0] = $1.1
            return dict
        }
    }
}
