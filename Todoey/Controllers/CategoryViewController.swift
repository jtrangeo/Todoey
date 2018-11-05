//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joseph Ng on 11/2/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
   // let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //grabs ref to context that we will be using to CRUD data, will also commmunicate with persistance container
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
      //  let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].name //the name property is here bc we added it as an attribute in the Category ENtity
        
        return cell
    }
    
    //MARK - Data Manipulation Methods -save data load data
    func saveCategories() {
        
        
        do { try context.save()
            
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData() //reloads n allows for new item to be added}
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) { //with ext param and request internal param, internal will be used in the function loadItem and with external param will be use down down there
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    //MARK - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the suer clicks the Add Item on our UI alert
            
            
           
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
//            newCategory.done = false
            self.categoryArray.append(newCategory)
            //! text prop is never of textfield is never going to = nil. even if its empty it will set to empty string
            
            self.saveCategories()
        
        }
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new category"
        }
        
        alert.addAction(action)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(cancelAction) //adds cancel button
        present(alert, animated: true, completion: nil)

        
    }
    
    //MARK - TableView Datasource Methods
    //this method triggers when we select one of the categ cells
    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath  = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        
    }
        //print(itemArray[indexPath.row])
        
        //below checks to see if there has been a checkmark when cilcked. if does then chk mk dissapoers when click
        
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveCategories()
        
        
       // tableView.deselectRow(at: indexPath, animated: true) //flashes selected row
        
    
}
}
