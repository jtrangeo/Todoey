//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph Ng on 10/22/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>? //an array of string
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //path of where data is being stored for our current app

        
       
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {// if todo itm is not nil, then grab the item@indexpath,row
        
            cell.textLabel?.text = item.title
    
        //ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
                }
            }catch {
                    print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        //below checks to see if there has been a checkmark when cilcked. if does then chk mk dissapoers when click
        
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true) //flashes selected row
    
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the suer clicks the Add Item on our UI alert
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()//initializing new object of item class
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
            }
            } catch {
                print("Error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
            //! text prop is never of textfield is never going to = nil. even if its empty it will set to empty string
            
         
        
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

//    func saveItems() {
//
//        do {
//            try context.save()
//            } catch {
//            print("Error saving context \(error)")
//            }
//
//        self.tableView.reloadData() //reloads n allows for new item to be added}
//    }

    
    func loadItems() { //with ext param and request internal param, internal will be used in the function loadItem and with external param will be use down down there
//        //let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %A", selectedCategory!.name!)
//
            todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [categoryPrediacte, predicate])
////
////        request.predicate = compoundPredicate
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        tableView.reloadData()
    }
}
//}


// MARK - Search Bar MEthods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true) //replaces all coredata below with realms here
        
//        let request :NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//       // print(searchBar.text!) used to see if save request is printd
//
//         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request)

        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async { //puts task below into foreground.
               searchBar.resignFirstResponder() //removes cursor and keyboard after you x out of search
            }
        }
    }
}
//
