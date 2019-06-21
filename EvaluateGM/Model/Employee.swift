//
//  Employee.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/12/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import Foundation
import UIKit

struct Employee {
    let photo: UIImage
    let name: String
    let lastName: String
    let type: Type
    var cultureAttatchment: Float = 0.0
    var dpoImplementation: Float = 0.0
    var attitude: Float = 0.0
    var trainingAdaptation: Float = 0.0
    var performance: Float = 0.0
    var average: Float {
        return (cultureAttatchment + dpoImplementation + attitude + trainingAdaptation + performance) / 5
    }
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

    init(photo: UIImage, name: String, lastName: String, type: Type) {
        self.photo = photo
        self.name = name
        self.lastName = lastName
        self.type = type
    }
}

enum Type {
    case forklift
    case delivery
    case warehouseAssistant
    case deliveryAssistant
}
