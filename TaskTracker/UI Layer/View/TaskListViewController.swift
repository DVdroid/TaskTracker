//
//  ViewController.swift
//  TaskTracker
//
//  Created by VA on 16/01/22.
//

import UIKit
import Combine

final class TaskListViewController: UIViewController {
    
    private var tasklistDisplayItem: TaskListDisplayItem = TaskListDisplayItem(with: [])
    var observableTaskListDisplayItem: ObservableTaskListDisplayItem
    required init?(coder: NSCoder, observableTaskListDisplayItem: ObservableTaskListDisplayItem) {
        self.observableTaskListDisplayItem = observableTaskListDisplayItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init?(coder: NSCoder) not implemented!!!")
    }
    
    private var cancellable: Set<AnyCancellable> = []
    private enum State {
        case noTaskFound
        case hasTask
    }
    
    private var state: State = .noTaskFound {
        didSet {
            switch state {
            case .noTaskFound:
                tableView.isHidden = true
            case .hasTask:
                tableView.isHidden = false
                tableView.reloadData()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TaskViewCell", bundle: .main), forCellReuseIdentifier: "taskViewCell")
        return tableView
    }()
    
    
    private func addSubViews() {
        addNoTaskViewAsSubview()
        addTaskListAsSubView()
    }
    
    private func addNoTaskViewAsSubview() {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Task Items!!!"
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addTaskListAsSubView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        addSubViews()
        
        observableTaskListDisplayItem.$tasklistDisplayItem.sink { [weak self] in
            self?.tasklistDisplayItem = $0
            self?.state = $0.tasks.count > 0 ? .hasTask : .noTaskFound
        }.store(in: &cancellable)
        
        state = tasklistDisplayItem.tasks.count > 0 ? .hasTask : .noTaskFound
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    @objc func addTapped(_ sender: UIBarButtonItem) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: .main)
        let addTaskVC = mainStoryBoard.instantiateViewController(identifier: "AddTaskViewController") { [unowned self] in
            AddTaskViewController(
                coder: $0,
                delegate: self
            )
        }
        
        navigationController?.present(addTaskVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
        navigationItem.setHidesBackButton(false, animated: false)
    }
}


extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasklistDisplayItem.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskViewCell") as? TaskViewCell else {
            return UITableViewCell()
        }
        
        let task = tasklistDisplayItem.tasks[indexPath.row]
        cell.title.text = task.title
        cell.checkBoxButton.isChecked = task.isComplete
        
        cell.checkBoxButton.checkBoxTapAction = { [weak self] isChecked in
            self?.tasklistDisplayItem.checkBoxTapAction?(isChecked, task)
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let tasksArray = Array(tasklistDisplayItem.tasks)
        let unwrappedTask = tasksArray[indexPath.row]
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: .main)
        let taskDetailsVC = mainStoryBoard.instantiateViewController(identifier: "TaskDetailsViewController") { [unowned self] in
            TaskDetailsViewController(
                coder: $0,
                task: unwrappedTask,
                delegate: self,
                updateTapAction: self.tasklistDisplayItem.updateTapAction
            )
        }
        
        show(taskDetailsVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let deletedTask = tasklistDisplayItem.tasks[indexPath.row]
            tasklistDisplayItem.removeTapAction?(deletedTask)
            
            tableView.endUpdates()
        }
    }
}

extension TaskListViewController: AddTaskViewControllerDelegate {
    
    func addTaskListView(_ addTaskListView: AddTaskViewController, didCreateNewTask task: TaskModel?) {
        guard let unwrappedTask = task else { return }
        tasklistDisplayItem.createTapAction?(unwrappedTask)
    }
}

extension TaskListViewController: TaskDetailsViewControllerDelegate {
    
    func taskDetailsView(_ taskDetailsView: TaskDetailsViewController, didUpdateTask task: TaskModel) {
        tasklistDisplayItem.updateTapAction?(task)
    }
}
