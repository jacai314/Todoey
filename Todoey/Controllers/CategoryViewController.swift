//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jae Chang on 12/2/19.
//  Copyright © 2019 JACAI. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
//        print(category)
        cell.textLabel?.text = category.name
        
//        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        print("the item is selected \(categoryArray[indexPath.row].name!)")
            
        performSegue(withIdentifier: "goToItems", sender: self)
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "goToItems" {
                print("goToItems has been selected.")
                let destinationVC = segue.destination as! TodoListViewController
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    destinationVC.selectedCategory = categoryArray[indexPath.row]
                }
            }
        }
    }

    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Category names", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category name", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()

            print("Success!")
            print(textField.text!)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    //MARK: - Data Manipulation Methods
    
    func saveCategory() {
        
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}
