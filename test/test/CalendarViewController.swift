//
//  ViewController.swift
//  test
//
//  Created by 松下亮太 on 2017/12/16.
//  Copyright © 2017年 松下亮太. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var Labelyear: UILabel!
    @IBOutlet weak var Labelmonth: UILabel!
    @IBOutlet weak var Labelday: UILabel!
    
    var Labelyear2: String?
    var Labelmonth2: String?
    var Labelday2: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    func calendar(_ calendar:FSCalendar, didSelect date: Date, at monthPosition:FSCalendarMonthPosition){
        let selectDay = getDay(date)
        Labelyear.text = String(selectDay.0)
        Labelmonth.text = String(selectDay.1)
        Labelday.text = String(selectDay.2)
        Labelyear2 = String(selectDay.0)
        Labelmonth2 = String(selectDay.1)
        Labelday2 = String(selectDay.2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputVc = segue.destination as! InputViewController
        inputVc.textYear2 = self.Labelyear.text
        inputVc.textMonth2 = self.Labelmonth.text
        inputVc.textDay2 = self.Labelday.text
    }
}

