//
//  AppointmentCell.swift
//  MyAppointments
//
//  Created by Aleksei Degtiarev on 23/05/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var isReccuring: UIImageView!
    
    
    func configureCell (item: Appointment){
        
        let formater = DateFormatter ()
        formater.dateFormat = "HH:mm"
        
        to.text = formater.string(from: item.end)
        from.text = formater.string(from: item.start)
        name.text = item.name
        isReccuring.isHidden = !item.isRecurring
    }
    
}
