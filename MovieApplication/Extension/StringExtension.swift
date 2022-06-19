//
//  StringExtension.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation

extension String {
    
    var convertDateFormat: String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"

        let oldDate = olDateFormatter.date(from: self)
        
        guard let oldDate = oldDate else { return self }

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd.MM.YYYY"

        return convertDateFormatter.string(from: oldDate)
    }
}

