//
//  DataSercice.swift
//  MyAppointments
//
//  Created by Aleksei Degtiarev on 24/05/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import Foundation

class DataService {
    
    static let instance = DataService()
    
    let fileName = "data"
    
    func loadJson( handler: @escaping (_ isFinished: Bool, _ appointments: [Appointment]?) -> ())  {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let jsonData = try decoder.decode(Appointments.self, from: data)
                
                handler(true, jsonData)
            } catch {
                print("error:\(error)")
            }
        }
        handler (false, nil)
    }
}
