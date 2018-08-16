//
//  ViewController.swift
//  Todoe🏀
//
//  Created by Daisymond on 8/16/18.
//  Copyright © 2018 Daisymond. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Glock14🔫"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "On a Niggah👨🏿"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go Boom💥"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as?  [Item] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // ternary Operator
        // value = condition ? valueIfTrue : valueIfFalse
        // adding an accessory type .checkmark to our cell
        // the following line replaced the if statement commented below
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        }
        //        else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    // MARK - TableView Delagates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // the following line replaces the if statement commented below this line of code
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //        if  itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        }
        //        else {
        //            itemArray[indexPath.row].done = false
        //        }
        
        tableView.reloadData()
        // makes the grey flash and disappear when the cell is selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Do Item", message: "add new item", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // What will happen what the add button is clicked
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            // adding the data to our app sandbox defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        // adding a textfield programatically on the UI Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)
    }
}

