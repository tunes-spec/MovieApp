
import Foundation

class Reminder: Codable {
    var title: String
    var date: Date
    var isCompleated: Bool
    
    init(title: String, date:Date, isCompleated: Bool) {
        self.title = title
        self.date = date
        self.isCompleated = isCompleated
    }
}

