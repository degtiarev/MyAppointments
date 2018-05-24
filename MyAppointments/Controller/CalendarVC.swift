//
//  CalendarVC.swift
//  MyAppointments
//
//  Created by Aleksei Degtiarev on 23/05/2018.
//  Copyright © 2018 Aleksei Degtiarev. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarVC: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    var delegate: MainVCDelegate?
    let formater = DateFormatter ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        let currentDay = Date()
        calendarView.selectDates([currentDay])
        calendarView.scrollToDate(currentDay)
    }
    
    
    func setupCalendarView () {
        // set up calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // setup labels
        calendarView.visibleDates { (visibleDates ) in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
    
    
    func setupViewOfCalendar (from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formater.dateFormat = "yyyy"
        self.year.text = self.formater.string(from: date)
        
        self.formater.dateFormat = "MMMM"
        self.month.text = self.formater.string(from: date)
    }
    
    
    func handleCellTextColor(view: JTAppleCell?, cellState:CellState )  {
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = UIColor.white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = UIColor.black
            } else {
                validCell.dateLabel.textColor = UIColor.gray
            }
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        delegate?.sendData(isFilteringByDate: false, dateToFilter: nil)
        dismiss(animated: true, completion: nil)
    }
}



extension CalendarVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formater.dateFormat = "yyyy MM dd"
        formater.timeZone = Calendar.current.timeZone
        formater.locale =  Calendar.current.locale
        
        let startDate = formater.date(from: "1970 01 01")!
        let endDate = formater.date(from: "2050 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
        //        if testCalendar.isDateInToday(date) {
        //            myCustomCell.backgroundColor = red
        //        } else {
        //            myCustomCell.backgroundColor = white
        //        }
    }
    
}



extension CalendarVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        
        
        myCustomCell.dateLabel.text = cellState.text
        if cellState.isSelected {
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        return myCustomCell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else {return }
        
        validCell.selectedView.isHidden = false
        handleCellTextColor(view: validCell, cellState: cellState)
        
        delegate?.sendData(isFilteringByDate: true, dateToFilter: date)
        dismiss(animated: true, completion: nil)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else {return }
        
        validCell.selectedView.isHidden = true
        handleCellTextColor(view: validCell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewOfCalendar(from: visibleDates )
    }
    
}
