//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joseph Ng on 11/2/18.
//  Copyright © 2018 Jo Ng. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm() //new access pt to realm database
    var categories: Results<Category>? //new collection  of results that are category objects: ? is used to be safe
   // let defaults = UserDefaults.standard
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //grabs ref to context that we will be using to CRUD data, will also commmunicate with persistance container
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //this could be nil bc category is an optional and we are only saying get the count of category is not nil. if it is nil, use 1 instead.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
      //  let category = category[indexPath.row]
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet" //the name property is here bc we added it as an attribute in the Category ENtity
        
        return cell
    }
    
    //MARK - Data Manipulation Methods -save data load data
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData() //reloads n allows for new item to be added}
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
  
//    with request: NSFetchRequest<Category> = Category.fetchRequest()) { //with ext param and request internal param, internal will be used in the function loadItem and with external param will be use down down there
//        // let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            category = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        tableView.reloadData() //auto update categ method in TableView Datasource
    }
    //MARK - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once the suer clicks the Add Item on our UI alert
           
            let newCategory = Category()
            newCategory.name = textField.text!
//            newCategory.done = false
          
            //! text prop is never of textfield is never going to = nil. even if its empty it will set to empty string
            
            self.save(category: newCategory)
        
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new category"
        }
        
        
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        
    }
        //print(itemArray[indexPath.row])
        
        //below checks to see if there has been a checkmark when cilcked. if does then chk mk dissapoers when click
        
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        //        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        save(category: newCategory)
        
        
       // tableView.deselectRow(at: indexPath, animated: true) //flashes selected row
        
    
    }
}
