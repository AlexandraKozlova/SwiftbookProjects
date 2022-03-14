//
//  NewEmojiTableViewController.swift
//  Emoji Reader
//
//  Created by Aleksandra on 06.08.2021.
//

import UIKit

class NewEmojiTableViewController: UITableViewController {
    
    var emoji = Emoji(emoji: "", name: "", description: "", isFavorite: false)

    @IBOutlet weak var emojiAdd: UITextField!
    @IBOutlet weak var nameAdd: UITextField!
    @IBOutlet weak var descriptionAdd: UITextField!
    @IBOutlet weak var save: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButtonState ()
        updateUI ()
    }
    
    private func saveButtonState () {
        let emoji = emojiAdd.text ?? " "
        let name = nameAdd.text ?? " "
        let description = descriptionAdd.text ?? " "
        save.isEnabled = !emoji.isEmpty && !name.isEmpty && !description.isEmpty
    }
    
    private func updateUI (){
        emojiAdd.text = emoji.emoji
        nameAdd.text = emoji.name
        descriptionAdd.text = emoji.description
    }

    @IBAction func textChanced(_ sender: UITextField) {
        saveButtonState ()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else {return}
        
        let emoji = emojiAdd.text ?? ""
        let name = nameAdd.text ?? ""
        let description = descriptionAdd.text ?? ""
        
        self.emoji = Emoji(emoji: emoji, name: name, description: description, isFavorite: self.emoji.isFavorite)
    }
}
