//
//  File 2.swift
//  
//
//  Created by Markus on 22.12.20.
//

import Foundation

extension Date {
    
    public init(withFitReferenceDate ti: TimeInterval) {
        // Fit file are in seconds since UTC 00:00 Dec 31 1989 = -347241600
        self.init(timeIntervalSinceReferenceDate: -347241600+ti)
    }
    
}
