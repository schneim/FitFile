//
//  File.swift
//  
//
//  Created by Markus on 18.12.20.
//

import Foundation

extension FitFile {
    
    class DataMessage {

        let definitonMessage:DefinitionMessage
 
        init(definition:DefinitionMessage) {
         
            self.definitonMessage = definition
        }
        
        
        func decode(from decoder:Decoder) {
            
            for field in self.definitonMessage.fields {
                
                
                
                decoder.iterator = decoder.iterator + Int(field.size)
                
            }
        }
    
    }


    
}
