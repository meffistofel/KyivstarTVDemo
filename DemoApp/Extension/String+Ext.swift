//
//  String+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/2/24.
//

import Foundation

extension String {
    func moveToNextLine() -> String {
        replacingOccurrences(of: ": ", with: ":\n")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
