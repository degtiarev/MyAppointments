//
//  Appointment.swift
//  MyAppointments
//
//  Created by Aleksei Degtiarev on 23/05/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import Foundation

typealias Appointments = [Appointment]

struct Appointment: Codable {
    
    let initials: [String]
    let end: Date
    let isRecurring: Bool
    let name: String
    let start: Date
    
}
