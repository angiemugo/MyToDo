//
//  ItemTableViewModel.swift
//  MyToDo
//
//  Created by Angie Mugo on 22/01/2018.
//  Copyright © 2018 Angie Mugo. All rights reserved.
//

import UIKit

class ItemTableViewModel {
    
    var alertTitle = "New To-Do Item"
    var alertMessage = "Insert the title of the new to-do item:"
    var actionTitle = "OK"
    
    var todoList = [ToDoItem]()

    private let defaults = UserDefaults.standard
    
    func addToDo(_ todoTitle: String) {
        todoList.append(ToDoItem(title: todoTitle))
    }
    
    func toggleDone(row: Int) {

        todoList[row].done = !todoList[row].done

    }
    
    func deleteItem(_ item: Int) {

        todoList.remove(at: item)

    }

    //MARK: fetch data from user defaults
    
    func fetchData() {
        
        if let list = defaults.value(forKey: "encodedList") as? [[String: Any]] {
            
            for item in list {
                guard let todoItem = ToDoItem(item) else { return }
                todoList.append(todoItem)
            }
        }
    }
    
    
    //MARK: Save data to user defaults
    
    func saveData() {
        
        var encodedList = [[String: Any]]()
        
        for item in todoList {
            guard let unwrappedItem = item.toPlist() else { return }

            encodedList.append(unwrappedItem)
        }
        defaults.set(encodedList, forKey: "encodedList")
    }
    
}
