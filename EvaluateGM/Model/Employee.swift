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
    
    //General qualifications
    var cultureAttatchmentArray: [Float] = []
    var cultureAttatchment: Float {
        if cultureAttatchmentArray.count == 0 {
            return 0.0
        } else {
            return cultureAttatchmentArray.reduce(0, +) / Float(cultureAttatchmentArray.count)
        }
    }
    
    var dpoImplementationArray: [Float] = []
    var dpoImplementation: Float {
        if cultureAttatchmentArray.count == 0 {
            return 0.0
        } else {
            return dpoImplementationArray.reduce(0, +) / Float(dpoImplementationArray.count)
        }
    }
    
    var attitudeArray: [Float] = []
    var attitude: Float {
        if attitudeArray.count == 0 {
            return 0.0
        } else {
            return attitudeArray.reduce(0, +) / Float(attitudeArray.count)
        }
    }
    
    var trainingAdaptationArray: [Float] = []
    var trainingAdaptation: Float {
        if trainingAdaptationArray.count == 0 {
            return 0.0
        } else {
            return trainingAdaptationArray.reduce(0, +) / Float(trainingAdaptationArray.count)
        }
    }
    
    var performanceArray: [Float] = []
    var performance: Float {
        if performanceArray.count == 0 {
            return 0.0
        } else {
            return performanceArray.reduce(0, +) / Float(performanceArray.count)
        }
    }
    
    var specificGradesArrays: [[Float]] = [[], [], [], [], [], []]
    var specificGrades: [Float] {
        //Any index
        if specificGradesArrays[0].count == 0 {
            return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        } else {
            switch type {
            case .forklift, .warehouseAssistant:
                return [specificGradesArrays[0].reduce(0, +) / Float(specificGradesArrays[0].count), specificGradesArrays[1].reduce(0, +) / Float(specificGradesArrays[1].count), specificGradesArrays[2].reduce(0, +) / Float(specificGradesArrays[2].count), specificGradesArrays[3].reduce(0, +) / Float(specificGradesArrays[3].count), specificGradesArrays[4].reduce(0, +) / Float(specificGradesArrays[4].count)]
            case .delivery, .deliveryAssistant:
                return [specificGradesArrays[0].reduce(0, +) / Float(specificGradesArrays[0].count), specificGradesArrays[1].reduce(0, +) / Float(specificGradesArrays[1].count), specificGradesArrays[2].reduce(0, +) / Float(specificGradesArrays[2].count), specificGradesArrays[3].reduce(0, +) / Float(specificGradesArrays[3].count), specificGradesArrays[4].reduce(0, +) / Float(specificGradesArrays[4].count), specificGradesArrays[5].reduce(0, +) / Float(specificGradesArrays[5].count)]
            }
        }
    }
    
    var average: Float {
        get {
            switch type {
            case .forklift, .warehouseAssistant:
                return (cultureAttatchment + dpoImplementation + attitude + trainingAdaptation + performance + specificGrades.reduce(0, +)) / 10
            case .delivery, .deliveryAssistant:
                return (cultureAttatchment + dpoImplementation + attitude + trainingAdaptation + performance + specificGrades.reduce(0, +)) / 11
            }
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
