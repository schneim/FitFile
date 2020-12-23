//
//  File.swift
//  
//
//  Created by Markus on 23.12.20.
//

import Foundation
import CRC

extension  FitFile {
    
    class Manager {
        
        let decoder:Decoder
        
        var messageTypes:Dictionary<UInt, DefinitionMessage>
        var dataMessages:Dictionary<MessageNumber,Array<DataMessage>>
        
        public init(data:Data) {
            self.decoder = Decoder(data: data)
            self.messageTypes = Dictionary<UInt, DefinitionMessage>()
            self.dataMessages = Dictionary<MessageNumber,Array<DataMessage>>()
        }
        
        public convenience init(fitFileURL:URL) {
            //open the URL an load the file as data
            do {
                let fitData = try Data(contentsOf: fitFileURL)
                self.init(data:fitData)
            } catch {
                print ("Unable to open FIT file")
                self.init(data: Data())
            }
        }
        
        func createDataMessage(localMessageType:UInt) -> DataMessage? {
            // create data message depending on globalMessageNumber
            guard let definitionMessage = self.messageTypes[localMessageType] else {
                return nil
            }
            
            var dataMessage:DataMessage? = nil
            
            switch definitionMessage.globalMessageNumber {
            case .fileId:
                dataMessage = FileIdMessage(definition: definitionMessage)
            case .deviceInfo:
                dataMessage = DeviceInfoMessage(definition: definitionMessage)
            case .record:
                dataMessage = RecordMessage(definition: definitionMessage)
            default:
                dataMessage = DataMessage(definition: definitionMessage)
            }
            
            if !self.dataMessages.keys.contains(definitionMessage.globalMessageNumber) {
                self.dataMessages.updateValue(Array(), forKey: definitionMessage.globalMessageNumber)
            }
            
            self.dataMessages[definitionMessage.globalMessageNumber]?.append(dataMessage!)
            
            return dataMessage
        }
        
        func loadFitFile()  {
            
            // check for file CRC
            let fileCRC = CRC16.crc(data: self.decoder.data.prefix(self.decoder.data.count-2)) // last two bytes are CRC
            guard fileCRC == self.decoder.data.suffix(2).to(type: UInt16.self) else {
                return
            }
            
            var header = FitFile.FileHeader()
            header.decode(from: self.decoder)
            
            guard header.data_type == ".FIT" else {
                return
            }
            var recordHeader = FitFile.RecordHeader()
            // read all data bytes from fit file
            while self.decoder.iterator < header.data_size {
                recordHeader.decode(from: self.decoder)
                
                if recordHeader.messageType == .definitionMessage {
                    var definitionMessage = FitFile.DefinitionMessage()
                    definitionMessage.decode(from: decoder)
                    self.messageTypes.updateValue(definitionMessage, forKey: recordHeader.localMessageType)
                } else {

                    guard let dataMessage = self.createDataMessage(localMessageType: recordHeader.localMessageType) else {
                        break
                    }
                    dataMessage.decode(from: self.decoder)
                }
                
            }
            
            
        }
    }
}
