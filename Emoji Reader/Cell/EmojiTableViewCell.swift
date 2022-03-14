//
//  EmojiTableViewCell.swift
//  Emoji Reader
//
//  Created by Aleksandra on 05.08.2021.
//

import UIKit

class EmojiTableViewCell: UITableViewCell {

    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discriptionLAbel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(object: Emoji) {
        self.emojiLabel.text = object.emoji
        self.nameLabel.text = object.name
        self.discriptionLAbel.text = object.description
    }
}
