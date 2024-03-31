//
//  Item.swift
//  BinBuddy
//
//  Created by Rayen Kamta on 3/30/24.
//

import Foundation
import SwiftData

@Model
class Item {
    @Attribute(.externalStorage) var image: Data // Image data is required and stored externally
    var name: String
    var idescription: String
    var locationOfStorage: String
    var quantity: Int
    var gpsCoords: String // GPS coordinates are required and stored as a string
    var timestamp: Date

    init(image: Data, name: String, idescription: String, locationOfStorage: String, quantity: Int, gpsCoords: String, timestamp: Date = .now) {
        self.image = image
        self.name = name
        self.idescription = idescription
        self.locationOfStorage = locationOfStorage
        self.quantity = quantity
        self.gpsCoords = gpsCoords
        self.timestamp = timestamp
    }
}
