//
//  ItemTableViewController.swift
//  MyToDo
//
//  Created by Angie Mugo on 17/01/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {

    var viewModel = ItemTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        configureView()
    }

    func configureView() {
        tableView.tableFooterView = UIView(frame: .zero)
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.tableView.bounds

        gradientLayer.colors =
            [UIColor.red.withAlphaComponent(5).cgColor,UIColor.yellow.withAlphaComponent(0.5).cgColor]
        let backgroundView = UIView(frame: self.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.backgroundView = backgroundView
    }

    @IBAction func didTapAdd(_ sender: Any) {
        let alert = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: viewModel.actionTitle, style: .default, handler: { (_) in
            
            guard let todoTitle = alert.textFields![0].text else { return }
            let newIndex = self.viewModel.todoList.count
            self.viewModel.addToDo(todoTitle)
            self.tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
            self.viewModel.saveData()
        }
        ))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoList .count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        if indexPath.row < viewModel.todoList.count
        {
            let item = viewModel.todoList[indexPath.row]
            cell.textLabel?.text = item.title
            
            //MARK: set the checkmark for item done
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
            
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < viewModel.todoList.count {

            viewModel.toggleDone(row: indexPath.row)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        viewModel.saveData()

    }
    
    //MARK: functionality for delete rows
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row < viewModel.todoList.count {
            viewModel.deleteItem(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
        viewModel.saveData()

    }

}
