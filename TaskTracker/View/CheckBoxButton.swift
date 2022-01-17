//
//  CheckBoxButton.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import UIKit

final class CheckBoxButton: UIButton {
    
    // Images
    let checkedImage = UIImage(named: Constant.checkedImageName)! as UIImage
    let uncheckedImage = UIImage(named: Constant.uncheckedImageName)! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            self.setImage(isChecked ? checkedImage : uncheckedImage, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.clear
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        if sender == self {
            isChecked.toggle()
        }
    }
}
