//
//  Double+Ext.swift
//  DemoApp
//
//  Created by Alex Kovalov on 11/3/24.
//

import Foundation

extension Double {
    func asString(
        style: DateComponentsFormatter.UnitsStyle,
        units: NSCalendar.Unit,
        zeroFormattingBehavior: DateComponentsFormatter.ZeroFormattingBehavior = .dropAll
    ) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = zeroFormattingBehavior
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
