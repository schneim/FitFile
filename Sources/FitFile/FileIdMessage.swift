//
//  File.swift
//  
//
//  Created by Markus on 21.12.20.
//

import Foundation

extension FitFile {
    
    class FileIdMessage:DataMessage {

       
   
        enum FieldDefinitionNumber:UInt {
            case type=0, manufacturer=1, product=2, serialNumber=3, timeCreated=4, number=5, productName=8
        }
        
        
        var type:UInt           = 0
        var manufacturer:UInt   = 0
        var product:UInt        = 0
        var serialNumber:UInt   = 0
        var timeCreated:Date    = Date()
        var number:UInt         = 0
        var productName:String  = ""
   
    
        
        
        override func decode(from decoder:Decoder) {
            
            for field in self.definitonMessage.fields {
                
                switch FieldDefinitionNumber(rawValue:field.definitionNumber) {
                case .type:
                    self.type = UInt(decoder.data[decoder.iterator])
                case .some(.manufacturer):
                    self.manufacturer = UInt(decoder.data[decoder.iterator ..< decoder.iterator+2].to(type: UInt16.self) ?? 0)
                case .some(.product):
                    self.product = UInt(decoder.data[decoder.iterator ..< decoder.iterator+2].to(type: UInt16.self) ?? 0)
                case .some(.serialNumber):
                    self.serialNumber = UInt(decoder.data[decoder.iterator ..< decoder.iterator+4].to(type: UInt32.self) ?? 0)
                case .some(.timeCreated):
                    // Fit file are in seconds since UTC 00:00 Dec 31 1989 = -347241600
                    self.timeCreated = Date(timeIntervalSinceReferenceDate: -347241600 + Double(decoder.data[decoder.iterator ..< decoder.iterator+4].to(type: UInt32.self) ?? 0))
                case .some(.number):
                    self.number = UInt(decoder.data[decoder.iterator ..< decoder.iterator+2].to(type: UInt16.self) ?? 0)
                case .some(.productName):
                    self.productName = String(decoder.data[decoder.iterator])
                case .none:
                    self.type = UInt(decoder.data[decoder.iterator])
                }
                
                decoder.iterator = decoder.iterator + Int(field.size)
                
            }
        }
    
    }


    
}

