//
//  NewReminderViewController.swift
//  Reminder
//
//  Created by TSUNE on 2021/03/27.
//

import UIKit

class NewReminderViewController: UIViewController {
    
    var reminderIndex:Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var compleatedSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let reminderIndex = reminderIndex {
            let reminder = ReminderService.shared.getReminder(index: reminderIndex)
            titleTextField.text = reminder.title
            datePicker.date = reminder.date
            compleatedSwitch.isOn = reminder.isCompleated
        }
    }
    @IBAction func saveButtonDidTapped(_ sender: UIButton) {
        let reminder = Reminder(title: titleTextField.text!, date: datePicker.date, isCompleated: compleatedSwitch.isOn)
        navigationController?.popViewController(animated: true)
        if let reminderIndex = reminderIndex {
            ReminderService.shared.update(reminder: reminder, index: reminderIndex)
        } else {
            ReminderService.shared.create(reminder: reminder)
        }
    }
}
