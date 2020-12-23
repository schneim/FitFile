//
//  File.swift
//  
//
//  Created by Markus on 21.12.20.
//

import Foundation

extension FitFile {
    
    class DeviceInfoMessage:DataMessage {

       
        enum FieldDefinitionNumber:UInt {
            case deviceIndex=0, deviceType=1,manufacturer=2, product=4, serialNumber=3, timestamp=253, productName=27
        }
        
        
        
        var deviceIndex:UInt    = 0
        var deviceType:UInt     = 0
        var manufacturer:UInt   = 0
        var serialNumber:UInt   = 0
        var product:UInt        = 0
        

        var productName:String  = ""
        var timestamp:Date      = Date()
    
       
        
        
        override func decode(from decoder:Decoder) {
            
            for field in self.definitonMessage.fields {
                
                switch FieldDefinitionNumber(rawValue:field.definitionNumber) {
                case .deviceIndex:
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .none:
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .some(.deviceType):
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .some(.manufacturer):
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .some(.product):
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .some(.serialNumber):
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .some(.timestamp):
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                case .some(.productName):
                    self.deviceIndex = UInt(decoder.data[decoder.iterator])
                }
                
                decoder.iterator = decoder.iterator + Int(field.size)
                
            }
        }
    
    }


    
}
