//
//  AddTaskViewController.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func addTaskListView(_ addTaskListView: AddTaskViewController, didCreateNewTask task: Task?)
}

final class AddTaskViewController: UIViewController {
    
    @IBOutlet var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet var titleTextField: UITextField! {
        didSet {
            titleTextField.placeholder = "Title"
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.delegate = self
            descriptionTextView.textColor = UIColor.lightGray
            descriptionTextView.text = "Task detail (optional)"
        }
    }
    
    weak var delegate: AddTaskViewControllerDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) not implemented!!!")
    }
    
    required init?(coder: NSCoder, delegate: AddTaskViewControllerDelegate) {
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        doneBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        descriptionTextView.resignFirstResponder()
        
        if let unwrappedTitleText = self.titleTextField.text, unwrappedTitleText.isEmpty,
           (self.descriptionTextView.textColor == UIColor.lightGray)  {
            
            delegate?.addTaskListView(self, didCreateNewTask: nil)
            dismiss(animated: true, completion: nil)
            
        } else if let unwrappedTitleText = self.titleTextField.text, unwrappedTitleText.isEmpty,
                  self.descriptionTextView.textColor != UIColor.lightGray {
            
            let task = Task(id: UUID().uuidString,
                            title: "New Task",
                            description: self.descriptionTextView.text ?? "",
                            isComplete: false)
            
            delegate?.addTaskListView(self, didCreateNewTask: task)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            guard let unwrappedTitleText = self.titleTextField.text,
                  !unwrappedTitleText.isEmpty else {
                      delegate?.addTaskListView(self, didCreateNewTask: nil)
                      dismiss(animated: true, completion: nil)
                      return
                  }
            
            let description = self.descriptionTextView.textColor != UIColor.lightGray ? self.descriptionTextView.text : nil
            let task = Task(id: UUID().uuidString,
                            title: unwrappedTitleText,
                            description: description,
                            isComplete: false)
            
            delegate?.addTaskListView(self, didCreateNewTask: task)
            dismiss(animated: true, completion: nil)
        }
    }
}


extension AddTaskViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
