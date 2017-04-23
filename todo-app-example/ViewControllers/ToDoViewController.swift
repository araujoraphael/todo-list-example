//
//  ToDoViewController.swift
//  todo-app-example
//
//  Created by Raphael Araújo on 4/22/17.
//  Copyright © 2017 Raphael Araujo. All rights reserved.
//

import UIKit
protocol ToDoViewControllerDelegate : AnyObject {
    func deleteToDoTapped(toDo: ToDo)
}

class ToDoViewController: UIViewController {
    @IBOutlet weak var textView : UITextView?
    var toDo: ToDo?
    var delegate: ToDoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if(self.toDo?.text != textView!.text) {
            self.toDo?.text = textView!.text
            self.toDo?.freeCopy().save()
        }
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent != nil && self.navigationItem.titleView == nil {
            initNavigationItemTitleView()
        }
    }
    
    private func initNavigationItemTitleView() {
        let titleView = UILabel()
        titleView.text = self.toDo?.name
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:.zero, size:CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    func setupViews() {
        self.navigationController?.setToolbarHidden(true, animated: false)
        if let toDo = toDo {
            self.textView?.text = toDo.text
            
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonTapped(_:)))
            
            let priorityButton = UIBarButtonItem(title: "Priority: \(toDo.priorityStr())", style: .done, target: self, action: #selector(priorityButtonTapped(_:)))
            self.navigationItem.setRightBarButtonItems([trashButton, priorityButton], animated: true)
        }
    }
    
    @objc private func titleWasTapped() {
        let alert = UIAlertController(title: "Edit TODO name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.toDo?.name
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            if let name = alert.textFields?.first?.text {
                if(name.replacingOccurrences(of: " ", with: "") != "") {
                    self.toDo?.name = name
                    self.toDo?.freeCopy().save()
                    if let titleView = self.navigationItem.titleView as? UILabel {
                        titleView.text = name
                        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
                        titleView.frame = CGRect(origin:.zero, size:CGSize(width: width, height: 500))
                        self.navigationItem.titleView = titleView
                    }
                } else {
                    self.showAlertError()
                }
            } else {
                self.showAlertError()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertError() {
        let alert = UIAlertController(title: "Error", message: "Name can't be blank", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func trashButtonTapped(_ sender : UIButton){
        guard let toDo = self.toDo else {
            return
        }
        delegate?.deleteToDoTapped(toDo: toDo)
        self.navigationController?.popViewController(animated: true)
    }
    
    func priorityButtonTapped(_ sender : UIButton){
        let actionSheet = UIAlertController(title: "Set TODO priority", message: "", preferredStyle: .actionSheet)
        let lowAction = UIAlertAction(title: "low", style: .default) { (UIAlertAction) in
            self.toDo?.priority = 0
            self.updatePriorityButtonTitle()
            self.toDo?.freeCopy().save()
        }
        
        let mediumAction = UIAlertAction(title: "medium", style: .default) { (UIAlertAction) in
            self.toDo?.priority = 1
            self.updatePriorityButtonTitle()
            self.toDo?.freeCopy().save()
        }
        
        let highAction = UIAlertAction(title: "high", style: .default) { (UIAlertAction) in
            self.toDo?.priority = 2
            self.updatePriorityButtonTitle()
            self.toDo?.freeCopy().save()
        }
        actionSheet.addAction(lowAction)
        actionSheet.addAction(mediumAction)
        actionSheet.addAction(highAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func updatePriorityButtonTitle(){
        if let toDo = self.toDo {
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonTapped(_:)))
            let priorityButton = UIBarButtonItem(title: "Priority: \(toDo.priorityStr())", style: .done, target: self, action: #selector(priorityButtonTapped(_:)))
            self.navigationItem.setRightBarButtonItems([trashButton, priorityButton], animated: true)
        }
    }
}
