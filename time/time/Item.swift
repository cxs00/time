//
//  Item.swift
//  time
//
//  Created by 单婉君 on 2025/10/18.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
