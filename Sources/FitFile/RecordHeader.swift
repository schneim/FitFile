//
//  Header.swift
//  
//
//  Created by Markus on 22.11.20.
//

import Foundation

extension  FitFile {


struct RecordHeader {
    
    public enum Layout:UInt8, RawRepresentable {
        case typeMask                   = 0x80,
             messageTypeMask            = 0x40,
             messageTypeSpecificMask    = 0x20,
             localMessageTypeMask       = 0x0F
    }
    
    public enum HeaderType:UInt {
        case normal=0, compressed
    }
    
    public enum MessageType:UInt {
        case definitionMessage = 1, dataMessage = 0
    }
    
    
    
    var type:HeaderType = .normal
    var messageType:MessageType = .definitionMessage
    var localMessageType:UInt = 0
    
    
    mutating func decode(from decoder:Decoder) {
        
        self.type             = HeaderType(rawValue: UInt((decoder.data[decoder.iterator] & Layout.typeMask.rawValue) >> 7 )) ?? .normal
        self.messageType      = MessageType(rawValue: UInt((decoder.data[decoder.iterator] & Layout.messageTypeMask.rawValue) >> 6 )) ?? .definitionMessage
        self.localMessageType = UInt(decoder.data[decoder.iterator] & Layout.localMessageTypeMask.rawValue)
        
        decoder.iterator = decoder.iterator + 1
        
    }
    
}
}
