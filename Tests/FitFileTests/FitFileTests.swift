import XCTest
import CRC
@testable import FitFile

final class FitFileTests: XCTestCase {
    func testHeaderDecode() {
        let headerData = Data(Array<UInt8>(arrayLiteral: 14,1,3,1,0xA,0xB,0xC,0xD,0x2e,0x46,0x49,0x54,0xd9,0x94))
        let crc = CRC16.crc(data: headerData.prefix(12))
        XCTAssertEqual(crc,0x94d9)
        let decoder = FitFile.Decoder(data: headerData)
        
        
        
        var header = FitFile.FileHeader()
        header.decode(from: decoder)
        
        XCTAssertEqual(header.size,14)
        XCTAssertEqual(header.protocol_version,1)
        XCTAssertEqual(header.profile_version,259)
        XCTAssertEqual(header.data_type,".FIT")
        XCTAssertEqual(header.data_size,218893066)
        
    }
    
    func testHeaderDecodeFromFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
        do {
            let fileData = try Data(contentsOf: resourceURL)
            XCTAssertEqual(fileData[0],12)
            // No header CRC
            let fileCRC = CRC16.crc(data: fileData.prefix(fileData.count-2)) // last two bytes are CRC
            XCTAssertEqual(fileCRC,0x18D6)
            let decoder = FitFile.Decoder(data: fileData)
            var header = FitFile.FileHeader()
            header.decode(from: decoder)
            
            XCTAssertEqual(header.size,12)
            XCTAssertEqual(header.protocol_version,16)
            XCTAssertEqual(header.profile_version,100)
            XCTAssertEqual(header.data_type,".FIT")
            XCTAssertEqual(header.data_size,122597)
            
            
        } catch {
            print ("Unable to open test file")
        }
    }

    
    func testRecordHeaderDecodeFromFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
        do {
            let fileData = try Data(contentsOf: resourceURL)
            XCTAssertEqual(fileData[0],12)
            // No header CRC
            let fileCRC = CRC16.crc(data: fileData.prefix(fileData.count-2)) // last two bytes are CRC
            XCTAssertEqual(fileCRC,0x18D6)
            let decoder = FitFile.Decoder(data: fileData)
            var header = FitFile.FileHeader()
            header.decode(from: decoder)
            
            XCTAssertEqual(header.size,12)
            XCTAssertEqual(header.protocol_version,16)
            XCTAssertEqual(header.profile_version,100)
            XCTAssertEqual(header.data_type,".FIT")
            XCTAssertEqual(header.data_size,122597)
            
            var recordHeader = FitFile.RecordHeader()
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.type,.normal)
            XCTAssertEqual(recordHeader.messageType,.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType, 0)
            
        } catch {
            print ("Unable to open test file")
        }
    }
    
    func testDefinitionMsgDecodeFromFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
        do {
            let fileData = try Data(contentsOf: resourceURL)
            XCTAssertEqual(fileData[0],12)
            // No header CRC
            let fileCRC = CRC16.crc(data: fileData.prefix(fileData.count-2)) // last two bytes are CRC
            XCTAssertEqual(fileCRC,0x18D6)
            let decoder = FitFile.Decoder(data: fileData)
            var header = FitFile.FileHeader()
            header.decode(from: decoder)
            
            XCTAssertEqual(header.size,12)
            XCTAssertEqual(header.protocol_version,16)
            XCTAssertEqual(header.profile_version,100)
            XCTAssertEqual(header.data_type,".FIT")
            XCTAssertEqual(header.data_size,122597)
            
            var recordHeader = FitFile.RecordHeader()
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.type,.normal)
            XCTAssertEqual(recordHeader.messageType,.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType, 0)
            
            
            var definitionMessage = FitFile.DefinitionMessage()
            
            definitionMessage.decode(from: decoder)
            
            XCTAssertEqual(definitionMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 0))
            
        } catch {
            print ("Unable to open test file")
        }
    }
    
    func testFileIdMsgDecodeFromFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
        do {
            let fileData = try Data(contentsOf: resourceURL)
            XCTAssertEqual(fileData[0],12)
            // No header CRC
            let fileCRC = CRC16.crc(data: fileData.prefix(fileData.count-2)) // last two bytes are CRC
            XCTAssertEqual(fileCRC,0x18D6)
            let decoder = FitFile.Decoder(data: fileData)
            var header = FitFile.FileHeader()
            header.decode(from: decoder)
            
            var recordHeader = FitFile.RecordHeader()
            recordHeader.decode(from: decoder)
            var definitionMessage = FitFile.DefinitionMessage()
            definitionMessage.decode(from: decoder)
            
            recordHeader.decode(from: decoder)
            let fileIdMessage = FitFile.FileIdMessage(definition: definitionMessage)
            
            fileIdMessage.decode(from: decoder)
            
            XCTAssertEqual(fileIdMessage.type,4)
            XCTAssertEqual(fileIdMessage.manufacturer,260)
            XCTAssertEqual(fileIdMessage.timeCreated.description,"2020-11-12 18:08:05 +0000")
            
        } catch {
            print ("Unable to open test file")
        }
    }
    
    func testRecordMsgDecodeFromFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
        do {
            let fileData = try Data(contentsOf: resourceURL)
            XCTAssertEqual(fileData[0],12)
            // No header CRC
            let fileCRC = CRC16.crc(data: fileData.prefix(fileData.count-2)) // last two bytes are CRC
            XCTAssertEqual(fileCRC,0x18D6)
            let decoder = FitFile.Decoder(data: fileData)
            var header = FitFile.FileHeader()
            header.decode(from: decoder)
            
            var recordHeader = FitFile.RecordHeader()
            recordHeader.decode(from: decoder)
            var definitionMessage = FitFile.DefinitionMessage()
            definitionMessage.decode(from: decoder)
            XCTAssertEqual(definitionMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 0))
            
            recordHeader.decode(from: decoder)
            let fileIdMessage = FitFile.FileIdMessage(definition: definitionMessage)
            fileIdMessage.decode(from: decoder)
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType,1)
            definitionMessage = FitFile.DefinitionMessage()
            definitionMessage.decode(from: decoder)
            XCTAssertEqual(definitionMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 23))  // Device Info Message
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,1)
            let deviceInfoMessage = FitFile.DeviceInfoMessage(definition: definitionMessage)
            deviceInfoMessage.decode(from: decoder)

 
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            var definitionRecordMessage = FitFile.DefinitionMessage()
            definitionRecordMessage.decode(from: decoder)
            XCTAssertEqual(definitionRecordMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 20))  // Record Message definition
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType,2)
            var definitionEventMessage = FitFile.DefinitionMessage()
            definitionEventMessage.decode(from: decoder)
            XCTAssertEqual(definitionEventMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 21)) // Event Message definition
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,2)
            let eventMessage = FitFile.DataMessage(definition: definitionEventMessage)
            eventMessage.decode(from: decoder)
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            let recordMessage = FitFile.RecordMessage(definition: definitionRecordMessage)
            recordMessage.decode(from: decoder)
            XCTAssertEqual(recordMessage.timestamp.description,"2020-11-12 18:30:15 +0000")
            XCTAssertEqual(recordMessage.heartRate,93)
            XCTAssertEqual(recordMessage.speed,8.078)
            XCTAssertEqual(recordMessage.cadence,64)
            XCTAssertEqual(recordMessage.distance,0.73)
            XCTAssertEqual(recordMessage.altitude,13)
            XCTAssertEqual(recordMessage.power,200)

            
            
            
        } catch {
            print ("Unable to open test file")
        }
    }
    
    func testDataMsgDecodeFromFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
        do {
            let fileData = try Data(contentsOf: resourceURL)
            XCTAssertEqual(fileData[0],12)
            // No header CRC
            let fileCRC = CRC16.crc(data: fileData.prefix(fileData.count-2)) // last two bytes are CRC
            XCTAssertEqual(fileCRC,0x18D6)
            let decoder = FitFile.Decoder(data: fileData)
            var header = FitFile.FileHeader()
            header.decode(from: decoder)
            
            var recordHeader = FitFile.RecordHeader()
            recordHeader.decode(from: decoder)
            var definitionMessage = FitFile.DefinitionMessage()
            definitionMessage.decode(from: decoder)
            XCTAssertEqual(definitionMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 0))
            
            recordHeader.decode(from: decoder)
            let fileIdMessage = FitFile.FileIdMessage(definition: definitionMessage)
            fileIdMessage.decode(from: decoder)
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType,1)
            definitionMessage = FitFile.DefinitionMessage()
            definitionMessage.decode(from: decoder)
            XCTAssertEqual(definitionMessage.globalMessageNumber,FitFile.MessageNumber(rawValue: 23))  // Device Info Message
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,1)
            let deviceInfoMessage = FitFile.DeviceInfoMessage(definition: definitionMessage)
            deviceInfoMessage.decode(from: decoder)

 
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            var definitionMessage3 = FitFile.DefinitionMessage()
            definitionMessage3.decode(from: decoder)
            XCTAssertEqual(definitionMessage3.globalMessageNumber,FitFile.MessageNumber(rawValue: 20))  // Record Message definition
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.definitionMessage)
            XCTAssertEqual(recordHeader.localMessageType,2)
            var definitionMessage2 = FitFile.DefinitionMessage()
            definitionMessage2.decode(from: decoder)
            XCTAssertEqual(definitionMessage2.globalMessageNumber,FitFile.MessageNumber(rawValue: 21)) // Event Message definition
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,2)
            let eventMessage = FitFile.DataMessage(definition: definitionMessage2)
            eventMessage.decode(from: decoder)
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            var recordMessage = FitFile.RecordMessage(definition: definitionMessage3)
            recordMessage.decode(from: decoder)
           
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            recordMessage = FitFile.RecordMessage(definition: definitionMessage3)
            recordMessage.decode(from: decoder)
            
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            recordMessage = FitFile.RecordMessage(definition: definitionMessage3)
            recordMessage.decode(from: decoder)
           
            recordHeader.decode(from: decoder)
            XCTAssertEqual(recordHeader.messageType,FitFile.RecordHeader.MessageType.dataMessage)
            XCTAssertEqual(recordHeader.localMessageType,3)
            recordMessage = FitFile.RecordMessage(definition: definitionMessage3)
            recordMessage.decode(from: decoder)
            
            
        } catch {
            print ("Unable to open test file")
        }
    }
    
    
    func testManagerLoadFile() {
        
        
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent("../zwift-activity-681959170286260144.fit")
        
            let manager =  FitFile.Manager(fitFileURL: resourceURL)
            manager.loadFitFile()
            
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 0)!]?.count,1)
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 18)!]?.count,1)
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 20)!]?.count,3297)
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 21)!]?.count,2)
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 23)!]?.count,1)
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 34)!]?.count,1)
        XCTAssertEqual(manager.dataMessages[FitFile.MessageNumber(rawValue: 19)!]?.count,1)
            
    
    }
    
    static var allTests = [
        ("testHeaderDecode", testHeaderDecode),
        ("testHeaderDecodeFromFile", testHeaderDecodeFromFile),
        ("testRecordHeaderDecodeFromFile", testRecordHeaderDecodeFromFile),
        ("testDefinitionMsgDecodeFromFile", testDefinitionMsgDecodeFromFile),
        ("testFileIdMsgDecodeFromFile", testFileIdMsgDecodeFromFile),
        ("testRecordMsgDecodeFromFile", testRecordMsgDecodeFromFile),
        ("testDataMsgDecodeFromFile", testDataMsgDecodeFromFile),
        ("testManagerLoadFile", testManagerLoadFile),
    ]
}
