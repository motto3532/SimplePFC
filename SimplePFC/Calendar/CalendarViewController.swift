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
        //rootでこの画面きたらすぐmealsへ移動
        Router.shared.showMeals(from: self, date: Date())
        
        calendar.calendarHeaderView.backgroundColor = .white
        calendar.calendarWeekdayView.backgroundColor = .white
        calendar.backgroundColor = .white
        calendar.appearance.headerDateFormat = "YYYY年MM月"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //dateはDate型だから、絶対時間(日本より9時間遅い)が格納されてる
        //print(date)
        Router.shared.showMeals(from: self, date: date)
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}
