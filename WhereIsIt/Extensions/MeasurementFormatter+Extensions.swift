//
//  MeasurementFormatter+Extensions.swift
//  WhereIsIt
//
//  Created by NJ Development on 21/09/23.
//

import Foundation

extension MeasurementFormatter {
    static var distance: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        formatter.locale = Locale.current
        return formatter
    }
}
