//
//  File.swift
//  
//
//  Created by Markus on 18.12.20.
//

import Foundation

extension FitFile {

struct Field {

    var definitionNumber:UInt = 0
    var size:UInt = 0
    var baseType:UInt = 0
    var endianAbility:Bool = true
    
    mutating func decode(from decoder:Decoder) {
        
        self.definitionNumber = UInt(decoder.data[decoder.iterator])
        decoder.iterator = decoder.iterator + 1
        
        self.size = UInt(decoder.data[decoder.iterator])
        decoder.iterator = decoder.iterator + 1
        
        self.baseType = UInt(decoder.data[decoder.iterator])
        decoder.iterator = decoder.iterator + 1
        
    }
}
}

