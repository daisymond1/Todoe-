//
//  ViewController.swift
//  Todoe🏀
//
//  Created by Daisymond on 8/16/18.
//  Copyright © 2018 Daisymond. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
                  loadItems()
        }
    }
    
    // context variable contains data before commiting to our main Persstant Container  Storage,
    // Only after commiting will it saved in the main SQLite database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    We are no longer using user Defaults to store data in our plist file in this program so Ignore this line of code and any user default related
    //    var defaults = UserDefaults.standard
    //  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(dataFilePath)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    }
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        /* ternary Operator
         value = condition ? valueIfTrue : valueIfFalse
         adding an accessory type .checkmark to our cell
         the following line replaced the if statement commented below
         */
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        
        /*        if item.done == true {
         cell.accessoryType = .checkmark
         }
         else {
         cell.accessoryType = .none
         }
         */
        return cell
    }
    
    // MARK: - TableView Delagates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* the following line replaces the if statement commented below this line of code
         it also updates the database, if in the app, I select the first row, the index is set to 0 and for that the .done is set to the opposite by the use of ! and it
         updates the context then the saveItems method allows us to commit those updated chabges to our persistant container/Database(SQLite)
         */
        // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        /* Deleting stuff from our database
         context.delete should be called first since we are using indexPath.row from the array to delete from the context,
         if we call context last after deleting from the array, it will have no where to delete from and there will be an error
         context.delete is deleting data from our Persistant Container/Database, so we call it and specify the item that we want deleted, but we have
         to save the context and commit it to the Persistant Container 
         itemArray.remove is removing data from the array that stores our information displayed on the view
         */
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        /*        if  itemArray[indexPath.row].done == false {
         itemArray[indexPath.row].done = true
         }
         else {
         itemArray[indexPath.row].done = false
         }
         */
        saveItems()
        
        // makes the grey flash and disappear when the cell is selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Do Item", message: "add new item", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // What will happen when the add button is clicked
            
            // manages rows in the database since every row is manged by as NSManger, in this case Item makes up our rows
            let newItem = Item(context: self.context)
            
            // title and done are the fields, attributes or properties we fill up
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            // this appends the item to our array of objects that appear on our phone, in the view
            self.itemArray.append(newItem)
            
            //after all that we save our items
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
    
    // MARK: - Model Manipulation Methods
    func saveItems() {
        
        /* adding the data to our app sandbox defaults
         instead of using the user defaults to store app data we are now using the NSEncoder
         property list which will encode our data namely iitem array into a property list as since only property lists can be saved and not regualr arrays or other data types
         self.defaults.set(self.itemArray, forKey: "TodoListArray")
         after testing NSEncoder, we deleted the code and we now save our data to the SQLite database denoted by Persistant Container
         Persistant Container which is fed with data from the contex, of which is the temporary storage where all edditing of data takes place
         before finally storing it
         */
        
        do {
            // this statement attempts and saves the new context object we made earlier and commits changes to our Persistant Data Storage/Database
            try context.save()
        }
        catch {
            print("Error Saving contex \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // this function reads data from the Persistant Container/Databse through the Contex
    // the output from this method is going to be an array of item sstored in our persistant container
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate =  NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }

        do{
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error Fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    /*
     // this function reads or load data from a plist it is however not used in this program
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
     */
}

// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
        
        
    }
    
    // method that allows us to get back to the whole list when search bar is cleared
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

