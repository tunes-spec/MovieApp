
import UIKit

class ReminderViewCell: UITableViewCell {
    
    @IBOutlet var isCompleatedView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(reminder: Reminder,index: Int ) {
        infoButton.tag = index
        titleLabel?.text = reminder.title
        isCompleatedView.layer .cornerRadius = 25
        isCompleatedView.layer.borderColor = UIColor.lightGray.cgColor
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy hh:mma"
        dateLabel.text = dateFormatter.string(from: reminder.date)
        
        if reminder.isCompleated  {
            isCompleatedView.backgroundColor = UIColor.systemGreen
            isCompleatedView.layer.borderWidth = 0.0
        } else {
            isCompleatedView.backgroundColor = UIColor.white
            isCompleatedView.layer.borderWidth = 2.0
        }
    }
}
