//
//  TaskViewCell.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet var checkBoxButton: CheckBoxButton!
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        checkBoxButton.isChecked = false
        title.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
