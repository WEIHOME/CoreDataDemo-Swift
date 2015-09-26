//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Weihong Chen on 02/05/2015.
//  Copyright (c) 2015 Weihong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var uiTableView: UITableView!
    
    var fruits = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiTableView.delegate = self
        self.uiTableView.dataSource = self
//        uiTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetch = NSFetchRequest(entityName: "Fruits")
        
        let result = try? managedContext.executeFetchRequest(fetch) as? [NSManagedObject]
        
        if let results = result{
            fruits = results!
        }else{
            print("Could not fetch")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fruits.count
    
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = fruits[indexPath.row].valueForKey("name") as? String
        let quantity = fruits[indexPath.row].valueForKey("quantity") as? Int
        cell.detailTextLabel?.text = "\(quantity!)"

        return cell
    }
    
    @IBAction func showAddingDialog(sender: UIBarButtonItem) {
        
        let dialog = UIAlertController(title: "Adding Fruit", message: "Adding", preferredStyle: UIAlertControllerStyle.Alert)
        
        let addFruitAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (_) -> Void in
        
            let textFieldForName = dialog.textFields![0]
            let textFieldForQuantity = dialog.textFields![1]

            
            self.addFruit(textFieldForName.text!, quantity: Int(textFieldForQuantity.text!)!)
        }
        
        
        let cancelAddingAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (_) -> Void in
            
        }
        
        
        
        dialog.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            textField.placeholder = "Fruit Name"
        }
        dialog.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
            textField.placeholder = "Fruit Quantity"
        }
        
        dialog.addAction(addFruitAction)
        dialog.addAction(cancelAddingAction)
        presentViewController(dialog, animated: true, completion: nil)
    }
    
    
    func addFruit(name: String, quantity: Int){
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Fruits", inManagedObjectContext: managedContext!)
        
        let fruit = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        fruit.setValue(name, forKey: "name")
        fruit.setValue(quantity, forKey: "quantity")
        
        let success = try? managedContext?.save()
        
        if success == nil{
            print("error")
            return
        }
        
        fruits.append(fruit)
        self.uiTableView.reloadData()
        print(fruits)
    }
    
    
    
}

