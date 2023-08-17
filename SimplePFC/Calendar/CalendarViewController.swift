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
    
    private var eventDates: [String] = []
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //次の画面のbackボタンをカレンダーに変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "カレンダー", style: .plain, target: nil, action: nil)
        
        //rootでこの画面きたらすぐmealsへ移動
        Router.shared.showMeals(from: self, date: Date())
        
        calendar.calendarHeaderView.backgroundColor = .white
        calendar.calendarWeekdayView.backgroundColor = .white
        calendar.backgroundColor = .white
        calendar.appearance.headerTitleColor = .gray
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.todayColor = .lightGray
        calendar.appearance.headerDateFormat = "YYYY年MM月"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.eventDates = []
        
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
        let realmRegistedData = MealRealm.shared.getMealsData()
        for data in realmRegistedData {
            let dateStr = self.dateFormatter.string(from: data.date)
            if !self.eventDates.contains(dateStr) {
                self.eventDates.append(dateStr)
            }
        }
        
        self.calendar.reloadData()
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //dateはDate型だから、絶対時間(日本より9時間遅い)が格納されてる
        Router.shared.showMeals(from: self, date: date)
        self.calendar.deselect(date)
    }
}

extension CalendarViewController: FSCalendarDataSource {
    
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateStr = dateFormatter.string(from: date)
        if self.eventDates.contains(dateStr) {
            return UIColor.systemMint
        } else {
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateStr = dateFormatter.string(from: date)
        if self.eventDates.contains(dateStr) {
            return UIColor.white
        } else {
            return nil
        }
    }
}
