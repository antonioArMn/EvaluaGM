//
//  User.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/12/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import Foundation
import UIKit

struct User {
    var name: String
    var lastName: String
    var email: String
    var password: String
    var isSupervisor: Bool
    var userId: String = ""
    
    init(name: String, lastName: String, email: String, password: String, isSupervisor: Bool) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.password = password
        self.isSupervisor = isSupervisor
    }
}
