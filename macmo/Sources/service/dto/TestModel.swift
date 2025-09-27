//
//  TestModel.swift
//  macmo
//
//  Created by 신동규 on 9/27/25.
//

import Foundation
import SwiftData

@Model
class TestModel {
    var name: String = ""

    init(name: String = "") {
        self.name = name
    }
}