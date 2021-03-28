//
//  ReminderViewController.swift
//  Reminder
//
//  Created by TSUNE on 2021/03/26.
//

import UIKit

class ReminderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateSegue", let newReminderViewController = segue.destination as? NewReminderViewController, let infoButton = sender as? UIButton {
            newReminderViewController.reminderIndex = infoButton.tag
        }
    }
    
    @IBAction func editButtonDidTapped(_ sender: Any) {
        if tableView.isEditing {
            tableView.isEditing = false
            self.title = "編集"
        } else {
            tableView.isEditing = true
            self.title = "実行"
        }
    }
    
    @IBAction func homeButtonDidTapped(_ sender: UIBarButtonItem) {
        showHomeApp()
    }
    
    private func showHomeApp() {
        let introAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "intro")
        if let windoewScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windoewScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = introAppViewController
            UIView.transition(with: window,
                              duration: 0.25,
                              options: .transitionCurlUp,
                              animations: nil,
                              completion: nil)
        }
    }
}

extension ReminderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ReminderService.shared.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderViewCell
        let reminder = ReminderService.shared.getReminder(index: indexPath.row)
        cell.update(reminder: reminder,index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ReminderService.shared.delete(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
