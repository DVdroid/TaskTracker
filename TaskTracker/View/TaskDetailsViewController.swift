//
//  TaskDetailsViewController.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import UIKit

protocol TaskDetailsViewControllerDelegate: AnyObject {
    func taskDetailsView(_ taskDetailsView: TaskDetailsViewController, didUpdateTask task: Task)
}

final class TaskDetailsViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    private var doneBarButtonItem: UIBarButtonItem?
    
    weak var delegate: TaskDetailsViewControllerDelegate?
    private var task: Task
    private var updateTapAction: ((Task)->Void)?
    required init?(coder: NSCoder,
                   task: Task,
                   delegate: TaskDetailsViewControllerDelegate,
                   updateTapAction: ((Task)->Void)?) {
        self.task = task
        self.delegate = delegate
        self.updateTapAction = updateTapAction
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) not implemented!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        doneBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.descriptionTextView.delegate = self
        self.titleLabel.text = task.title
        
        if task.description == nil {
            descriptionTextView.textColor = UIColor.lightGray
            descriptionTextView.text = "Task detail (optional)"
        } else {
            self.descriptionTextView.textColor = UIColor { $0.userInterfaceStyle == .dark ? .white : .black }
            self.descriptionTextView.text = task.description
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        descriptionTextView.resignFirstResponder()
        var updatedTask = task
        updatedTask.description = self.descriptionTextView.text ?? ""
        updateTapAction?(updatedTask)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        var updatedTask = task
        let description = self.descriptionTextView.textColor != UIColor.lightGray ? self.descriptionTextView.text : nil
        updatedTask.description = description
        delegate?.taskDetailsView(self, didUpdateTask: updatedTask)
    }
}

extension TaskDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = nil
    }
}
