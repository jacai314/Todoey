//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jae Chang on 12/2/19.
//  Copyright © 2019 JACAI. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.") }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBar.backgroundColor!, returnFlat: true)]
    }
    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let currentCategory = categories?[indexPath.row] {
            cell.textLabel?.text = currentCategory.name
            if let backgroundColor = currentCategory.backgroundColor {
                cell.backgroundColor = UIColor(hexString: backgroundColor)
            } else {
                let backgroundColor = UIColor.randomFlat().hexValue()
                cell.backgroundColor = UIColor(hexString: backgroundColor)
                do {
                    try realm.write {
                        currentCategory.backgroundColor = backgroundColor
                    }
                } catch {
                    print("Error deleting category \(error)")
                }
            }
            
            guard let categoryColor = UIColor(hexString: currentCategory.backgroundColor!) else { fatalError("fatal error of the current category color") }
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No Categories Added Yet"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        print("the item is selected \(String(describing: (categories?[indexPath.row].name)!))")
            
        performSegue(withIdentifier: "goToItems", sender: self)
            
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            if identifier == "goToItems" {
                print("goToItems has been selected.")
                let destinationVC = segue.destination as! TodoListViewController
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    destinationVC.selectedCategory = categories?[indexPath.row]
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
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)

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
    
    func save(category: Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        

        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let currentCategory = categories?[indexPath.row] {

            do {
                try realm.write {
                    realm.delete(currentCategory)
                }
            } catch {
                print("Error deleting category \(error)")
            }

        }
    }
}

