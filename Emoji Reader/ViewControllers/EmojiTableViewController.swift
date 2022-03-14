//
//  EmojiTableViewController.swift
//  Emoji Reader
//
//  Created by Aleksandra on 03.08.2021.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var object = [Emoji(emoji: "😢", name: "Cry", description: "Cry me a river", isFavorite: false),
     Emoji(emoji: "💃🏼", name: "Dance", description: "Lets dance", isFavorite: false),
     Emoji(emoji: "🥰", name: "Love", description: "I love you", isFavorite: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Emoji Reader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindSegue (segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            object[selectedIndexPath.row] =  emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
        
        let newIdexPath = IndexPath(row: object.count, section: 0)
        object.append(emoji)
        tableView.insertRows(at: [newIdexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editEmoji" else {return}
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = object [indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Edit"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return object.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let object = object [indexPath.row]
        cell.set(object: object)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          object.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade )
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = object.remove(at: sourceIndexPath.row)
        object.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favourite = favouriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, favourite])
    }
    
    func doneAction (at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, complection) in
            self.object.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            complection (true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage (systemName: "checkmark.circle")
        return action
    }
    
    func favouriteAction (at indexPath: IndexPath) -> UIContextualAction {
        var object = object [indexPath.row]
        let action = UIContextualAction (style: .normal, title: "Favourite") { (action, view, complection) in
            object.isFavorite = !object.isFavorite
            self.object[indexPath.row] = object
            complection(true)
        }
        action.backgroundColor = object.isFavorite ? .systemPink : .systemGray
        action.image = UIImage (systemName: "heart")
        return action
    }
}
