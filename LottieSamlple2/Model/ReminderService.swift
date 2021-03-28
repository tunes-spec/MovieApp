//
//  ReminderService.swift
//  Reminder
//
//  Created by TSUNE on 2021/03/23.
//

import Foundation

class ReminderService {
    static let shared = ReminderService()
    private var reminders = [Reminder]()
    private var url: URL
    
    private init() {
        url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        url.appendPathComponent("reminder json!")
        load()
    }
    
    
    func load() {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            reminders = try decoder.decode([Reminder].self, from: data)
        } catch {
            print("error loading\(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reminders)
            try data.write(to: url)
        } catch {
            print("error saving file\(error.localizedDescription)")
        }
    }
    
    //Create
    func create(reminder:Reminder) {
        //Add reminder to reminders array in a sorted order
        var inderxToInsert: Int?
        for (index,element) in reminders.enumerated() {
            if element.date.timeIntervalSince1970 > reminder.date.timeIntervalSince1970 {
                inderxToInsert = index
                break
            }
        }
        
        if inderxToInsert != nil {
            reminders.insert(reminder, at: inderxToInsert!)
        } else {
            reminders.append(reminder)
        }
        save()
    }
    //Update
    func update(reminder:Reminder,index:Int) {
        reminders[index] = reminder
        save()
    }
    //Get of reminders
    func getCount() -> Int {
        return reminders.count
    }
    //Get specific reminder
    func getReminder(index:Int) -> Reminder {
        return reminders[index]
    }
    
    //Get the list of a reminder
    func getReminders() -> [Reminder] {
        return reminders
    }
    //Delete a reminder
    func delete(index:Int) {
        reminders.remove(at: index)
        save()
    }
    //Get the favoriteReminder
    func getFavoritedReminder() -> Reminder? {
        return reminders.first
    }
}
