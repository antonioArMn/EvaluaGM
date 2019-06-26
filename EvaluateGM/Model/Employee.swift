//
//  Employee.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/12/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import Foundation
import UIKit

struct Employee: Equatable, Comparable {
    
    //General properties
    var photo: UIImage = UIImage(named: "User")!
    let name: String
    let lastName: String
    let type: Type
    var cultureAttatchment: Float = 0.0
    var dpoImplementation: Float = 0.0
    var attitude: Float = 0.0
    var trainingAdaptation: Float = 0.0
    var performance: Float = 0.0
    var specificGrades: [Float] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var average: Float {
        switch type {
        case .forklift, .warehouseAssistant:
            return (cultureAttatchment + dpoImplementation + attitude + trainingAdaptation + performance + specificGrades.reduce(0, +)) / 10
        case .delivery, .deliveryAssistant:
            return (cultureAttatchment + dpoImplementation + attitude + trainingAdaptation + performance + specificGrades.reduce(0, +)) / 11
        }
    }
    
    //Specific properties
    var typeString: String {
        switch type {
        case .forklift:
            return "Montacarga"
        case .delivery:
            return "Reparto"
        case .warehouseAssistant:
            return "Asistente de almacén"
        case .deliveryAssistant:
            return "Asistente de reparto"
        }
    }
    
    //Constructor
    init(name: String, lastName: String, type: Type) {
        self.name = name
        self.lastName = lastName
        self.type = type
    }
    
    //Methods
    static func ==(lhs: Employee, rhs: Employee) -> Bool {
        return lhs.name == rhs.name && lhs.lastName == rhs.lastName
    }
    
    static func < (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.name < rhs.name
    }
}

enum Type {
    case forklift
    case delivery
    case warehouseAssistant
    case deliveryAssistant
}
