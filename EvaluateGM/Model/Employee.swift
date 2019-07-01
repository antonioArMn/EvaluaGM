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
    var name: String
    var lastName: String
    var type: Type
    
    //General qualifications
    //Culture Attatchment Starts
    var cultureAttatchmentArray: [Float] = [] {
        didSet {
            if oldValue.count > 0{
                if((oldValue.reduce(0,+) / Float(oldValue.count)) < (cultureAttatchmentArray.reduce(0,+) / Float(cultureAttatchmentArray.count))) {
                    cultureAttatchmentIndicator = true
                } else if((oldValue.reduce(0,+) / Float(oldValue.count)) == (cultureAttatchmentArray.reduce(0,+) / Float(cultureAttatchmentArray.count))) {
                    cultureAttatchmentIndicator = true
                } else {
                    cultureAttatchmentIndicator = false
                }
            } else {
                cultureAttatchmentIndicator = true
            }
        }
    }
    var cultureAttatchmentIndicator: Bool = true
    //Culture Attatchment Ends
    //DPO Implementation Starts
    var dpoImplementationArray: [Float] = [] {
        didSet {
            if oldValue.count > 0{
                if((oldValue.reduce(0,+) / Float(oldValue.count)) < (dpoImplementationArray.reduce(0,+) / Float(dpoImplementationArray.count))) {
                    dpoImplementationIndicator = true
                } else if((oldValue.reduce(0,+) / Float(oldValue.count)) == (dpoImplementationArray.reduce(0,+) / Float(cultureAttatchmentArray.count))) {
                    dpoImplementationIndicator = true
                } else {
                    dpoImplementationIndicator = false
                }
            } else {
                dpoImplementationIndicator = true
            }
        }
    }
    var dpoImplementationIndicator: Bool = true
    //DPO Implementation Ends
    //Attitude Starts
    var attitudeArray: [Float] = [] {
        didSet {
            if oldValue.count > 0{
                if((oldValue.reduce(0,+) / Float(oldValue.count)) < (attitudeArray.reduce(0,+) / Float(attitudeArray.count))) {
                    attitudeIndicator = true
                } else if((oldValue.reduce(0,+) / Float(oldValue.count)) == (attitudeArray.reduce(0,+) / Float(attitudeArray.count))) {
                    attitudeIndicator = true
                } else {
                    attitudeIndicator = false
                }
            } else {
                attitudeIndicator = true
            }
        }
    }
    var attitudeIndicator: Bool = true
    //Attitude Ends
    //Training adaptation starts
    var trainingAdaptationArray: [Float] = [] {
        didSet {
            if oldValue.count > 0{
                if((oldValue.reduce(0,+) / Float(oldValue.count)) < (trainingAdaptationArray.reduce(0,+) / Float(trainingAdaptationArray.count))) {
                    trainingAdaptationIndicator = true
                } else if((oldValue.reduce(0,+) / Float(oldValue.count)) == (trainingAdaptationArray.reduce(0,+) / Float(trainingAdaptationArray.count))) {
                    trainingAdaptationIndicator = true
                } else {
                    trainingAdaptationIndicator = false
                }
            } else {
                trainingAdaptationIndicator = true
            }
        }
    }
    var trainingAdaptationIndicator: Bool = true
    //Training adaptation ends
    //Performance starts
    var performanceArray: [Float] = [] {
        didSet {
            if oldValue.count > 0{
                if((oldValue.reduce(0,+) / Float(oldValue.count)) < (performanceArray.reduce(0,+) / Float(performanceArray.count))) {
                    performanceIndicator = true
                } else if((oldValue.reduce(0,+) / Float(oldValue.count)) == (performanceArray.reduce(0,+) / Float(performanceArray.count))) {
                    performanceIndicator = true
                } else {
                    performanceIndicator = false
                }
            } else {
                performanceIndicator = true
            }
        }
    }
    var performanceIndicator: Bool = true
    //Performance ends
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
    
    var averageArray: [Float] = [] {
        didSet {
            if oldValue.count > 0{
                if((oldValue.reduce(0,+) / Float(oldValue.count)) < (averageArray.reduce(0,+) / Float(averageArray.count))) {
                    averageIndicator = true
                } else if((oldValue.reduce(0,+) / Float(oldValue.count)) == (averageArray.reduce(0,+) / Float(averageArray.count))) {
                    averageIndicator = true
                } else {
                    averageIndicator = false
                }
            } else {
                averageIndicator = true
            }
        }
    }
    var averageIndicator: Bool = true
    
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
    
    func getGeneralAverage() -> Float {
        if averageArray.count == 0 {
            return 0.0
        } else {
            return averageArray.reduce(0, +) / Float(averageArray.count)
        }
    }
    
    func getCultureAttatchmentAverage() -> Float {
        if cultureAttatchmentArray.count == 0 {
            return 0.0
        } else {
            return cultureAttatchmentArray.reduce(0, +) / Float(cultureAttatchmentArray.count)
        }

    }
    
    func getDpoImplementationAverage() -> Float {
        if dpoImplementationArray.count == 0 {
            return 0.0
        } else {
            return dpoImplementationArray.reduce(0, +) / Float(dpoImplementationArray.count)
        }
        
    }
    
    func getAttitudeAverage() -> Float {
        if attitudeArray.count == 0 {
            return 0.0
        } else {
            return attitudeArray.reduce(0, +) / Float(attitudeArray.count)
        }
        
    }
    
    func getTrainingAdaptationAverage() -> Float {
        if trainingAdaptationArray.count == 0 {
            return 0.0
        } else {
            return trainingAdaptationArray.reduce(0, +) / Float(trainingAdaptationArray.count)
        }
        
    }
    
    func getPerformanceAverage() -> Float {
        if performanceArray.count == 0 {
            return 0.0
        } else {
            return performanceArray.reduce(0, +) / Float(performanceArray.count)
        }
        
    }
}

enum Type {
    case forklift
    case delivery
    case warehouseAssistant
    case deliveryAssistant
}
