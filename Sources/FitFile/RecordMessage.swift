//
//  File.swift
//  
//
//  Created by Markus on 21.12.20.
//

import Foundation


extension FitFile {
    
    class RecordMessage:DataMessage {

       
   
        enum FieldDefinitionNumber:UInt {
            case        Timestamp = 253,
                        PositionLat = 0,
                        PositionLong = 1,
                        Altitude = 2,
                        HeartRate = 3,
                        Cadence = 4,
                        Distance = 5,
                        Speed = 6,
                        Power = 7
            
        }
        
        

        var positionLat     = 0
        var positionLong    = 0
        var speed:Double    = 0
        var altitude        = 0
        var timestamp       = Date()
        var heartRate:UInt  = 0
        var cadence:UInt    = 0
        var distance:Double = 0
        var power:UInt      = 0
        

        override func decode(from decoder:Decoder) {
            
            for field in self.definitonMessage.fields {
                switch FieldDefinitionNumber(rawValue:field.definitionNumber) {
                case .Timestamp:
                    self.timestamp = Date(withFitReferenceDate: Double(decoder.data[decoder.iterator ..< decoder.iterator+4].to(type: UInt32.self) ?? 0))
                    
                case .some(.PositionLat):
                    self.positionLat  = Int(decoder.data[decoder.iterator ..< decoder.iterator+4].to(type: UInt32.self) ?? 0)
                case .some(.PositionLong):
                    self.positionLong = Int(decoder.data[decoder.iterator ..< decoder.iterator+4].to(type: UInt32.self) ?? 0)
                case .some(.Altitude):
                    self.altitude = Int((UInt(decoder.data[decoder.iterator ..< decoder.iterator+2].to(type: UInt16.self) ?? 0) / 5 ) - 500)
                case .some(.HeartRate):
                    self.heartRate = UInt(decoder.data[decoder.iterator])
                case .some(.Cadence):
                    self.cadence = UInt(decoder.data[decoder.iterator])
                case .some(.Distance):
                    self.distance = Double(UInt(decoder.data[decoder.iterator ..< decoder.iterator+4].to(type: UInt32.self) ?? 0)) / 100
                case .some(.Speed):
                    self.speed = Double(UInt(decoder.data[decoder.iterator ..< decoder.iterator+2].to(type: UInt16.self) ?? 0)) / 1000
                case .some(.Power):
                    self.power = UInt(decoder.data[decoder.iterator ..< decoder.iterator+2].to(type: UInt16.self) ?? 0)
                case .none: break
                    
                }
                
                
                decoder.iterator = decoder.iterator + Int(field.size)
                
            }
        }
    
    }


    
}
