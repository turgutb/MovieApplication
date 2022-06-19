//
//  StringExtension.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation

extension String {
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        let pickerlang = Locale(identifier: "tr")
        dateFormatter.locale = pickerlang
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    var convertDateFormat: String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"

        let oldDate = olDateFormatter.date(from: self)
        
        guard let oldDate = oldDate else { return self }

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd.MM.YYYY"

        return convertDateFormatter.string(from: oldDate)
    }
    

    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "dd.MM.YYYY"

         return convertDateFormatter.string(from: oldDate!)
    }
}

