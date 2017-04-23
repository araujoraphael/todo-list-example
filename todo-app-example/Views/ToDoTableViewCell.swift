//
//  ToDoTableViewCell.swift
//  todo-app-example
//
//  Created by Raphael Araújo on 4/21/17.
//  Copyright © 2017 Raphael Araujo. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var notePreviewLabel : UILabel?
    @IBOutlet weak var dateLabel : UILabel?
    @IBOutlet weak var checkImage : UIImage?
    @IBOutlet weak var checkImageLeftOffset : NSLayoutConstraint?
    
    var toDo: ToDo? {
        didSet {
            layoutSubviews()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        editin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.notePreviewLabel?.text = toDo?.name
        self.dateLabel?.text = toDo?.lastUpdatedStr()
    }
    
}
