//
//  StuffController.swift
//  Nano1
//
//  Created by Levina Niolana on 26/04/22.
//

import UIKit
import CoreData

class StuffController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var categoryName: String?
  var rowSelected: Int?
  var isStuffSelected: Bool = false
  var category: Category?
  var stuff: Stuff?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //data for category table
  var stuffData: [Stuff]?
  var filteredData: [Stuff]!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      //set navigation bar
//      navigationItem.backBarButtonItem?.tintColor = UIColor(named: "Dark Sea Green")
//      navigationItem.title = categoryName
      navigationItem.title = category?.categoryName
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStuffTapped))
      navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "Dark Sea Green")

      //table
      tableView.register(UINib(nibName: "CustomStuffTableCell", bundle: nil), forCellReuseIdentifier: "cell")
      tableView.delegate = self
      tableView.dataSource = self
      
      //search bar
      searchBar.delegate = self
      
      //get item from core data
      getStuff()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getStuff()
  }
  
  func getStuff(){    
    //fetch data from core data
    do{
      let request = Stuff.fetchRequest() as NSFetchRequest<Stuff>

      //set filter
      let pred = NSPredicate(format: "has.categoryName CONTAINS %@", categoryName!)
      request.predicate = pred
      
      stuffData = try context.fetch(request)

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }catch{
      //error
      print("No Data")
    }
  }
  
  @objc func addStuffTapped() {
    performSegue(withIdentifier: "stuffToDetail", sender: nil)
  }
  
}

//MARK: Search Bar
extension StuffController: UISearchBarDelegate{
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredData = []
    
    if searchText == ""{
     getStuff()
    }else{
      if let stuff = stuffData{
        for stuff in stuffData!{
          if ((stuff.stuffName?.uppercased().contains(searchText.uppercased())) == true) {
            filteredData?.append(stuff)
          }else{
          }
        }
      }
    
      stuffData = filteredData
      self.tableView.reloadData()
    }
  }
}

//MARK: Table
extension StuffController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stuffData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomStuffTableCell
    
    if ((stuffData?.isEmpty) != nil) {
      cell?.stuffNameUI.text = stuffData![indexPath.row].stuffName
      cell?.locationUI.text = stuffData![indexPath.row].stuffLocation
      cell?.statusUI.text = stuffData![indexPath.row].stuffStatus
    }else{
    }
    
    return cell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    isStuffSelected.toggle()

    rowSelected = indexPath.row
    
    self.stuff = stuffData![rowSelected!]
    
    performSegue(withIdentifier: "stuffToDetail", sender: nil)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var nextVC = segue.destination as? StuffDetailController
    
    //check if stuff selected
    if isStuffSelected == true {
      nextVC?.stuffName = stuffData![rowSelected!].stuffName
      nextVC?.location = stuffData![rowSelected!].stuffLocation
      nextVC?.status = stuffData![rowSelected!].stuffStatus
      nextVC?.note = stuffData![rowSelected!].stuffNote
      isStuffSelected.toggle()
    }
    
    //passing category
    nextVC?.category = self.category
    
    //passing stuff
    nextVC?.stuff = self.stuff
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
  
    //delete
    let delete = UIContextualAction(style: .normal, title: "Delete") { [self](action, view, completionHandler)  in

      //delete category core data
      context.delete(stuffData![indexPath.row])
      
      //save
      do{
        try context.save()
      }
        catch{
        //error
      }
      
      //reload table
      getStuff()

    }
    delete.image = UIImage(systemName: "trash")
    delete.backgroundColor = UIColor(named: "Charcoal")
    
    //edit
    let edit = UIContextualAction(style: .normal, title: "Edit") {(action, view, completionHandler) in
      
      self.isStuffSelected.toggle()
      
      self.stuff = self.stuffData![indexPath.row]
      
      //open detail
      self.performSegue(withIdentifier: "stuffToDetail", sender: nil)
    }
    
    edit.image = UIImage(systemName: "pencil")
    edit.backgroundColor = UIColor(named: "Hookers Green")
    
    let action = UISwipeActionsConfiguration(actions: [delete, edit])
    return action
  }
}
