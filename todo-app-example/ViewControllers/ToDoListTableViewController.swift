//
//  ToDoListTableViewController.swift
//  todo-app-example
//
//  Created by Raphael Araújo on 4/22/17.
//  Copyright © 2017 Raphael Araujo. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    @IBOutlet weak var sortingByButton : UIBarButtonItem?
    var numberOfRows = 5
    var sortingBy = "date"
    var toDos = [ToDo]()
    var filteredToDos = [ToDo]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")

        initSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredToDos = sortedToDosBy(toDos: ToDo.list(), sortBy: sortingBy)
        self.tableView.reloadData()
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.isEditing = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredToDos.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ToDoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoTableViewCell
        
        cell.toDo = filteredToDos[indexPath.row].freeCopy()

        return cell
    }
 
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDo = filteredToDos[indexPath.row].freeCopy()
        self.performSegue(withIdentifier: "ToDoSegue", sender: toDo)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDo = filteredToDos[indexPath.row]
            toDo.delete()
            filteredToDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ToDoSegue") {
            let toDoVC = segue.destination as! ToDoViewController
            let toDo = sender as! ToDo
            toDoVC.toDo = toDo
            toDoVC.delegate = self
        }
    }
    
    // MARK: - IBAction methods

    @IBAction func priorityButtonTapped(sender: AnyObject){
        let actionSheet = UIAlertController(title: "Sort by", message: "", preferredStyle: .actionSheet)
        let dateAction = UIAlertAction(title: "Date", style: .default) { (UIAlertAction) in
            self.sortingByButton?.title = "date"
            self.sortingBy = "date"
            self.filteredToDos = self.sortedToDosBy(toDos: self.filteredToDos, sortBy: self.sortingBy)
            self.tableView.reloadData()
        }
        
        let priorityAction = UIAlertAction(title: "Priority", style: .default) { (UIAlertAction) in
            self.sortingByButton?.title = "priority"
            self.sortingBy = "priority"
            self.filteredToDos = self.sortedToDosBy(toDos: self.filteredToDos, sortBy: self.sortingBy)
            self.tableView.reloadData()
        }
        actionSheet.addAction(dateAction)
        actionSheet.addAction(priorityAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func editTapped(sender: AnyObject) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBAction func newTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "What is the new ToDo name?", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (alertAction) in
            if let name = alert.textFields?.first?.text {
                if(name.replacingOccurrences(of: " ", with: "") != "") {
                    let toDo = ToDo()
                    toDo.name = name
                    self.filteredToDos.append(toDo)
                    self.filteredToDos = self.sortedToDosBy(toDos: self.filteredToDos, sortBy: self.sortingBy)
                    self.performSegue(withIdentifier: "ToDoSegue", sender: toDo)
                } else {
                    self.showAlertError()
                }
            } else {
                self.showAlertError()
            }
           
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sortedToDosBy(toDos: [ToDo], sortBy: String) -> [ToDo] {
        let sortedToDos = toDos.sorted(by: { (toDo1, toDo2) -> Bool in
            var sorted = false
            if(sortingBy == "date") {
                sorted = toDo1.lastUpdated < toDo2.lastUpdated
            } else if (sortingBy == "priority") {
                sorted = toDo1.priority < toDo2.priority
            }
            return sorted
        })
        return sortedToDos
    }
    
    func showAlertError() {
        let alert = UIAlertController(title: "Error", message: "Name can't be blank", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ToDoListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        searchBy(text: text)
    }
    // MARK: - Searching and filtering
    func searchBy(text: String) {
        if(text != "") {
            filteredToDos = toDos.filter({ (toDo) -> Bool in
                toDo.name.lowercased().contains(text.lowercased())
            })
            filteredToDos = sortedToDosBy(toDos: filteredToDos, sortBy: sortingBy)
        } else {
            filteredToDos.removeAll()
            filteredToDos.append(contentsOf: sortedToDosBy(toDos: toDos, sortBy: sortingBy))
        }
        tableView.reloadData()
    }
}

extension ToDoListTableViewController: ToDoViewControllerDelegate {
    func deleteToDoTapped(toDo: ToDo) {
        guard let index = filteredToDos.index(of: toDo) else {
            return
        }
        filteredToDos.remove(at: index)
    }
}
