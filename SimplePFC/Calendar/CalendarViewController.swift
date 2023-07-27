//
//  CalendarViewController.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/07/26.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController{
    
    @IBOutlet private weak var calendar: FSCalendar! {
        didSet {
            calendar.delegate = self
            calendar.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.calendarHeaderView.backgroundColor = .green
        calendar.calendarWeekdayView.backgroundColor = .gray
        calendar.backgroundColor = .white
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Router.shared.showMeals(from: self)
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}
