//
//  CalendarPresenter.swift
//  SimplePFC
//
//  Created by Atto Rari on 2023/08/20.
//

import Foundation

protocol CalendarPresenterInput {
    func viewDidLoad()
    func reloadEventsData()
    func didSelect(date: Date)
    func defaultColorFor(date: Date, hasEvent: () -> Void)
}

protocol CalendarPresenterOutput: AnyObject {
    func showMeals(date: Date)
    func reloadData()
    func deselect(date: Date)
}

final class CalendarPresenter {
    private weak var output: CalendarPresenterOutput!
    private var eventDates: [String] = []
    private let dateFormatter = DateFormatter()
    
    init(output: CalendarPresenterOutput) {
        self.output = output
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
    }
}

extension CalendarPresenter: CalendarPresenterInput {
    func viewDidLoad() {
        //rootでカレンダー画面きたらすぐmealsへ移動
        self.output.showMeals(date: Date())
    }
    
    func reloadEventsData() {
        self.eventDates = []
        
        let realmRegistedData = MealRealm.shared.getMealsData()
        for data in realmRegistedData {
            let dateStr = dateFormatter.string(from: data.date)
            if !self.eventDates.contains(dateStr) {
                self.eventDates.append(dateStr)
            }
        }
        
        self.output.reloadData()
    }
    
    func didSelect(date: Date) {
        self.output.deselect(date: date)
        self.output.showMeals(date: date)
    }
    
    func defaultColorFor(date: Date, hasEvent: () -> Void) {
        let dateStr = dateFormatter.string(from: date)
        if self.eventDates.contains(dateStr) {
            hasEvent()
        }
    }
}
