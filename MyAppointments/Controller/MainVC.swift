//
//  ViewController.swift
//  MyAppointments
//
//  Created by Aleksei Degtiarev on 23/05/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit


class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var appointments: [Appointment]?
    var filteredAppointments: [Appointment]?
    var sections = Dictionary<String, Array<Appointment>>()
    var sortedSections = [String]()
    
    var isFilteringByDate: Bool = false
    var dateToFilter: Date?
    let formater = DateFormatter ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.instance.loadJson(handler: { (isFinished, appointments) in
            if isFinished {
                
                self.appointments = appointments
                self.createSections()
            }
            
        })
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFilteringByDate {
            
            segment.selectedSegmentIndex = 1
            filteredAppointments = appointments?.filter {
                return Calendar.current.compare($0.start, to: dateToFilter!, toGranularity: .day) == .orderedSame
            }
            
            formater.dateFormat = "dd-MM-yyyy"
            let date = formater.string(from:dateToFilter!)
            segment.setTitle(date, forSegmentAt: 1)
            
        } else {
            
            segment.selectedSegmentIndex = 0
        }
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarVC" {
            
            let navVC = segue.destination as? UINavigationController
            let calendarVC = navVC?.viewControllers.first as! CalendarVC
            calendarVC.delegate = self
        }
    }
    
    
    func createSections () {
        
        for appointment in appointments! {
            
            formater.dateFormat = "dd-MM-yyyy"
            let date = formater.string(from:appointment.start)
            
            if sections.index(forKey: date) == nil {
                sections[date] = [appointment]
            } else {
                sections[date]!.append(appointment)
            }
        }
        
        sortedSections = sections.keys.sorted()
    }
    
    
    @IBAction func segmenttedControlValueChanged(_ sender: Any) {
        
        if segment.selectedSegmentIndex == 0 {
            isFilteringByDate = false
            tableView.reloadData()
            segment.setTitle("Selected Date", forSegmentAt: 1)
            
        } else if segment.selectedSegmentIndex == 1 {
            performSegue(withIdentifier: "CalendarVC", sender: nil)
        }
    }
    
}



extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath)  as? AppointmentCell {
            
            let appointment: Appointment!
            
            if isFilteringByDate {
                
                appointment = filteredAppointments![indexPath.row]
                
            } else {
                
                let appointmentSection = sections[sortedSections[indexPath.section]]
                appointment = appointmentSection![indexPath.row]
            }
            
            cell.configureCell(item: appointment)
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilteringByDate {
            return filteredAppointments!.count
        } else {
            return sections[sortedSections[section]]!.count
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFilteringByDate {
            return  1
        } else {
            return sections.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section]
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isFilteringByDate {
            return  0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
}



protocol MainVCDelegate: class {
    func sendData(isFilteringByDate: Bool, dateToFilter: Date?)
}


extension MainVC: MainVCDelegate {
    
    func sendData(isFilteringByDate: Bool, dateToFilter: Date?) {
        self.isFilteringByDate = isFilteringByDate
        self.dateToFilter = dateToFilter
    }
    
}

