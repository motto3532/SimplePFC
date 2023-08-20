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
    
    private var presenter: CalendarPresenterInput!
    
    func inject(presenter: CalendarPresenterInput){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //次の画面のbackボタンをカレンダーに変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "カレンダー", style: .plain, target: nil, action: nil)
        
        calendar.calendarHeaderView.backgroundColor = .white
        calendar.calendarWeekdayView.backgroundColor = .white
        calendar.backgroundColor = .white
        calendar.appearance.headerTitleColor = .gray
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.todayColor = .lightGray
        calendar.appearance.headerDateFormat = "YYYY年M月"
        calendar.firstWeekday = 2
        calendar.calendarWeekdayView.weekdayLabels[0].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "土"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "日"
        
        self.presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.reloadEventsData()
    }
}

extension CalendarViewController: CalendarPresenterOutput {
    func deselect(date: Date) {
        self.calendar.deselect(date)
    }
    
    func reloadData() {
        self.calendar.reloadData()
    }
    
    func showMeals(date: Date) {
        Router.shared.showMeals(from: self, date: date)
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.presenter.didSelect(date: date)
    }
}

extension CalendarViewController: FSCalendarDataSource {
}

extension CalendarViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        var fillDefaultColor: UIColor? = nil
        
        let hasEvent = { () -> Void in
            fillDefaultColor = UIColor.systemMint
        }
        
        self.presenter.defaultColorFor(date: date, hasEvent: hasEvent)
        
        return fillDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        var titleDefaultColor: UIColor? = nil
        
        let hasEvent = { () -> Void in
            titleDefaultColor = UIColor.white
        }
        
        self.presenter.defaultColorFor(date: date, hasEvent: hasEvent)
        
        return titleDefaultColor
    }
}
