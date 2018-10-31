//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph Ng on 10/22/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]() //an array of string
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        

        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
        //below checks to see if there has been a checkmark when cilcked. if does then chk mk dissapoers when click
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true) //flashes selected row
    
    }
    
    //MARK - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the suer clicks the Add Item on our UI alert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //! text prop is never of textfield is never going to = nil. even if its empty it will set to empty string
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
    
            
        }
        
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction) //adds cancel button
        present(alert, animated: true, completion: nil)
    }

//MARK - Model Manipulation Methods

func saveItems() {
    
        let encoder = PropertyListEncoder()
    
        do {
            let data = try encoder.encode(itemArray) // will encode our Item  array into property list. next step is to write data to our filepath
            try data.write(to: dataFilePath!)
            } catch {
            print("Error encoding item array, \(error)")
            }
    
        self.tableView.reloadData() //reloads n allows for new item to be added}
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder ()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}
