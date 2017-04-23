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
    @IBOutlet weak var priorityLabel : UILabel?
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.notePreviewLabel?.text = toDo?.name
        self.dateLabel?.text = toDo?.lastUpdatedStr()
        if(self.toDo?.priority == 0) {
            self.priorityLabel?.text = "low"
            self.priorityLabel?.backgroundColor = UIColor(red: 49.0/255, green: 115.0/255, blue: 51.0/255, alpha: 1.0)            }
        else if (self.toDo?.priority == 1) {
            self.priorityLabel?.text = "medium"
            self.priorityLabel?.backgroundColor = UIColor(red: 237.0/255, green: 121.0/255, blue: 6.0/255, alpha: 1.0)
        } else if (self.toDo?.priority == 2) {
            self.priorityLabel?.text = "high"
            self.priorityLabel?.backgroundColor = UIColor(red: 145.0/255, green: 52.0/255, blue: 19.0/255, alpha: 1.0)
        }
    }
}
