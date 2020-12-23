//
//  File.swift
//  
//
//  Created by Markus on 18.12.20.
//

import Foundation

extension FitFile {
    
    struct DefinitionMessage {
        
        enum Endianess:UInt {
            case littleEndian=0, bigEndian=1
        }
        
        var architecture:Endianess = .littleEndian
        var globalMessageNumber:MessageNumber = .invalid
        var numberOfFields:UInt = 0
        var fields:Array<Field> = Array()
        
     
        mutating func decode(from decoder:Decoder) {
            
            decoder.iterator = decoder.iterator + 1  // skip reserved byte
            
            self.architecture =  Endianess(rawValue: UInt(decoder.data[decoder.iterator])) ?? .littleEndian
            decoder.iterator = decoder.iterator + 1
            
            self.globalMessageNumber = MessageNumber(rawValue: UInt(decoder.data[decoder.iterator ..< decoder.iterator+2 ].to(type: UInt16.self) ?? 0)) ?? .invalid
            decoder.iterator = decoder.iterator + 2
            
            self.numberOfFields = UInt(decoder.data[decoder.iterator])
            decoder.iterator = decoder.iterator + 1
            
            
            
            for _ in 1...numberOfFields {
                
                var field = Field()
                
                field.decode(from: decoder)
                self.fields.append(field)
                
            }
        }
    }    
}
