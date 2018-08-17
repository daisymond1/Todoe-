//
//  ViewController.swift
//  Todoe🏀
//  🏀🏀🏀🏀🏀
//  Created by Daisymond on 8/16/18.
//  Copyright © 2018 Daisymond. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //    We are no longer using user Defaults in this program so Ignore this line of code and any user default related
    //    var defaults = UserDefaults.standard
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
     loadItems()
        
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
        
        saveItems()
 
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
            self.saveItems()
    
        }
        
        // adding a textfield programatically on the UI Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion:  nil)
    }
    
    // MARK - Model Manipulation Methods
    func saveItems() {
        
        // adding the data to our app sandbox defaults
        // instead of using the user defaults to store app data we are now using the NSEncoder
        // self.defaults.set(self.itemArray, forKey: "TodoListArray")
        
        let encoder = PropertyListEncoder()
        
        // property list which will encode our data namely iitem array into a property list as since only property lists can be saved and not regualr arrays or other data types
        do {
            let data = try encoder.encode(self.itemArray)
            // write the data to our datafile path
            try data.write(to: self.dataFilePath!)
        }
            
        catch {
            print("Error Encoding Item Array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems()  {
        
        if let data = try?  Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                 itemArray = try decoder.decode( [Item].self, from: data)
            }
            catch {
                print("Error decoding Item Array, \(error)")
            }
        }
    }
}

