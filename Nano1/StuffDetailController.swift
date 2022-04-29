//
//  StuffDetailViewController.swift
//  Nano1
//
//  Created by Levina Niolana on 27/04/22.
//

import UIKit

class StuffDetailController: UIViewController {

  @IBOutlet weak var stuffNameUI: UITextField!
  @IBOutlet weak var locationUI: UITextField!
  @IBOutlet weak var noteUI: UITextView!
  @IBOutlet weak var statusUI: UITextField!
  @IBOutlet weak var rightBarBtnUI: UIBarButtonItem!

  //passing data
  var stuffName: String?
  var location: String?
  var status: String?
  var note: String?
  var category: Category?
  var stuff: Stuff?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set style
    noteUI.layer.borderWidth = 1
    noteUI.layer.borderColor = UIColor.systemGray6.cgColor
    
    //set data
    if ((stuffName?.isEmpty) != nil) {
      stuffNameUI.text = stuffName
      locationUI.text = location
      statusUI.text = status
      noteUI.text = note
      
      //change bar button title -> add to save
      rightBarBtnUI.title = "Save"
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presentingViewController?.viewWillDisappear(true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    presentingViewController?.viewWillAppear(true)
  }
  
  @IBAction func cancelTapped(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion:nil)
  }
  
  @IBAction func addTapped(_ sender: Any) {
    if rightBarBtnUI.title == "Add"{
    
      //create category Object
      let newStuff = Stuff(context: self.context)
      newStuff.stuffName = stuffNameUI.text
      newStuff.stuffLocation = locationUI.text
      newStuff.stuffStatus = statusUI.text
      newStuff.stuffNote = noteUI.text
      
      stuff = newStuff.self
      
      //add stuff to category
      if let temp = category{
        temp.addToPartOf(newStuff)
      }
    }else{
      //save new update
      if let temp = stuff{
        temp.stuffName = stuffNameUI.text
        temp.stuffLocation = locationUI.text
        temp.stuffStatus = statusUI.text
        temp.stuffNote = noteUI.text
      }
    }
    
    //save data
    do{
      try self.context.save()
    }
      catch{
      //error
    }
    self.presentingViewController?.dismiss(animated: true, completion:nil)
  }
}


