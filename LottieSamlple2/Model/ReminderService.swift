
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
    
    func update(reminder:Reminder,index:Int) {
        reminders[index] = reminder
        save()
    }
    
    func getCount() -> Int {
        return reminders.count
    }
    
    func getReminder(index:Int) -> Reminder {
        return reminders[index]
    }
    
    func getReminders() -> [Reminder] {
        return reminders
    }
    
    func delete(index:Int) {
        reminders.remove(at: index)
        save()
    }
    
    func getFavoritedReminder() -> Reminder? {
        return reminders.first
    }
}
