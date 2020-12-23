//
//  Header.swift
//  
//
//  Created by Markus on 22.11.20.
//

import Foundation

extension  FitFile {


struct FileHeader {
    
    public enum Layout:Int {
        case size,
             protocoVersion,
             profileVersion,
             dataSize,
             dataType,
             CRC
        
        var range:Range<Int> {
            switch self{
            case .size:             return  0 ..< 1
            case .protocoVersion:   return  1 ..< 2
            case .profileVersion:   return  2 ..< 4
            case .dataSize:         return  4 ..< 8
            case .dataType:         return  8 ..< 12
            case .CRC:              return 12 ..< 14
            }
        }
        
        
    }
    
    
    var size:UInt               = 0
    var protocol_version:UInt   = 0
    var profile_version:UInt    = 0
    var data_size:UInt          = 0
    var data_type:String        = ""
    var crc:UInt16              = 0

    
    
    mutating func decode(from decoder:Decoder) {
        self.size             = UInt(decoder.data[(FileHeader.Layout.size.range)].to(type: UInt8.self) ?? 0)
        self.protocol_version = UInt(decoder.data[(FileHeader.Layout.protocoVersion.range)].to(type: UInt8.self) ?? 0)
        self.profile_version  = UInt(decoder.data[(FileHeader.Layout.profileVersion.range)].to(type: UInt16.self) ?? 0)
        self.data_size        = UInt(decoder.data[(FileHeader.Layout.dataSize.range)].to(type: UInt32.self) ?? 0)
        self.data_type        = String(data: decoder.data[(FileHeader.Layout.dataType.range)], encoding: .utf8)!
        if (self.size == 14) {
            self.crc              = decoder.data[(FileHeader.Layout.CRC.range)].to(type: UInt16.self) ?? 0
        }
        decoder.iterator = decoder.iterator + Int(self.size)

    }
    
}
}
