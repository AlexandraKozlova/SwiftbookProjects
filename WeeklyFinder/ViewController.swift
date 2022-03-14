//
//  ViewController.swift
//  WeeklyFinder
//
//  Created by Aleksandra on 02.08.2021.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var monthTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var result: UILabel!
    
    @IBAction func findDay(_ sender: UIButton) {
        guard let day = dateTF.text, let month = monthTF.text, let year = yearTF.text else {return}
        let calendar = Calendar.current
        var dateComponets = DateComponents()
        dateComponets.day = Int(day)
        dateComponets.month = Int(month)
        dateComponets.year = Int(year)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE"
        dateFormat.locale = Locale(identifier: "ru_Ru")
        
        guard let date = calendar.date(from: dateComponets) else {return}
        let weekday = dateFormat.string(from: date)
        let capitalazedWeekDay = weekday.capitalized
        result.text = capitalazedWeekDay
    }
}


