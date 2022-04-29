//
//  ViewController.swift
//  Nano1
//
//  Created by Levina Niolana on 26/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController{

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var rowSelected : Int?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var category: Category?
  
  //data for category table
  var categoryData: [Category]?
  var filteredData: [Category]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //alert color
    UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "Dark Sea Green")
    
    //table
    tableView.delegate = self
    tableView.dataSource = self
    
    //get item from core data
    getCategory()
    
    //search bar
    searchBar.delegate = self
  }
  
  // MARK: Get category
  func getCategory(){
    //fetch data from core data
    do{
      self.categoryData = try context.fetch(Category.fetchRequest())

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }catch{
      //error
      print("No Data")
    }
  }
  
  // MARK: Add Category
  @IBAction func AddCategoryTapped(_ sender: UIButton) {
    let alert = UIAlertController(title: "Add Category", message: "What is your category name?", preferredStyle: .alert)
    
    //add field
    alert.addTextField { field in
      field.placeholder = "Category Name"
    }
 
    //add button
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: {_ in
      //get category name
      guard let textField = alert.textFields![0].text else{
        print("No data")
        return
      }
     
      //create category Object
      let newCategory = Category(context: self.context)
      newCategory.categoryName = textField
      self.category = newCategory
      
      //save context
      do{
        try self.context.save()
      }
        catch{
        //error
      }
      
     //fetch data
      self.getCategory()
    }))
            
    //present the alert
    present(alert, animated: true)
  }
}

// MARK: Search bar
extension ViewController: UISearchBarDelegate{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    filteredData = []
    
    if searchText == ""{
     getCategory()
    }else{
      if let category = categoryData{
        for category in categoryData!{
          if ((category.categoryName?.uppercased().contains(searchText.uppercased())) == true) {
            filteredData?.append(category)
          }else{
          }
        }
      }
    
      categoryData = filteredData
      self.tableView.reloadData()
    }
  }
}

// MARK: Table
extension ViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    cell?.textLabel?.text = categoryData![indexPath.row].categoryName
    return cell ?? UITableViewCell()
  }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    rowSelected = indexPath.row
    performSegue(withIdentifier: "categoryToStuff", sender: nil)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nextVC = segue.destination as? StuffController
    
    nextVC?.categoryName = categoryData![rowSelected!].categoryName
    nextVC?.category = categoryData![rowSelected!]
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
    //delete
    let delete = UIContextualAction(style: .normal, title: "Delete") { [self](action, view, completionHandler)  in

      //delete category core data
      context.delete(categoryData![indexPath.row])
      
      //save
      do{
        try context.save()
      }
        catch{
        //error
      }
      
      //reload table
      getCategory()

    }
    delete.image = UIImage(systemName: "trash")
    delete.backgroundColor = UIColor(named: "Charcoal")
    
    //edit
    let edit = UIContextualAction(style: .normal, title: "Edit") {(action, view, completionHandler)  in
      let alert = UIAlertController(title: "Category", message: "Tap to edit category name", preferredStyle: .alert)
      
      //add field
      alert.addTextField { field in
        field.placeholder = "Category Name"
        field.text = self.categoryData![indexPath.row].categoryName
      }
   
      //add button
      alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
        
        //get new category name
        guard let textField = alert.textFields![0].text else{
          print("No data")
          return
        }
          
        //edit category name
        self.categoryData![indexPath.row].categoryName = textField
        
        //save
        do{
          try self.context.save()
        }
          catch{
          //error
            print("Error")
        }
        
        //reload table
        self.getCategory()
      }))
        
      //present the alert
      self.present(alert, animated: true)
    }
    
    edit.image = UIImage(systemName: "pencil")
    edit.backgroundColor = UIColor(named: "Hookers Green")
    
    let action = UISwipeActionsConfiguration(actions: [delete, edit])
    return action
  }
}
