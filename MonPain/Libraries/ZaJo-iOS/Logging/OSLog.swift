//
//  OSLog.swift
//  MonPain
//
//  Created by Jonathan Duss on 24.10.20.
//  Copyright © 2020 ZaJo. All rights reserved.
//

import Foundation

import os.log

public class OSLog {
    
    private static let HEADER_LENGTH = 30
    
    public static func log(message: String, file: String = #file, function: String = #function) {
        
        
        let filename = (file as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        var header = "\(filename).\(function)"

        
        if (header.count > HEADER_LENGTH) {
            let headerSubstring = header[header.startIndex..<header.index(header.startIndex, offsetBy: 25)]
            header = String(headerSubstring)
        }
        else {
            let missing = HEADER_LENGTH - header.count
            
            var added = 0
            while (added != missing) {
                added += 1
                header += " "
            }
        }
        
        os_log("%@", type: .debug, "[\(header)] \(message)")
    }
    
}
