//
//  MealTableViewController.swift
//  FoodManagerment
//
//  Created by CNTT on 4/22/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    //Mark: Properties
    var meals = [Meal]()
    enum NavigationType {
        case newMeal
        case editMeal
    }
    
    var navigationType:NavigationType = .newMeal
    
    // Definition of database object
    let dao = DatabaseLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create example of meals for tesing table table view
//        let mealImage = UIImage(named: "default")
//        if let meal = Meal(mealName: "Ca Hap", ratingValue: 4, mealImage: mealImage){
//            meals += [meal]
//        }
        
        // Add the Edit Menu in to the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Read all meals from database
        dao.readMeals( meals: &meals )
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "MealsTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? MealTableViewCell
        {
            //Get meal from array of meal (meals) at position of indexPath
            let meal = meals[indexPath.row]
            //Set meal into the cell
            cell.lblMealName.text = meal.mealName
            cell.imgMeal.image = meal.mealImage
            cell.ratingControl.setratingValue(ratingValue: meal.ratingValue)
            return cell
        }
        else{
            fatalError("no")
        }

        // Configure the cell...

        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete from datasource
            meals.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Identifying edit meal or new meal
        if let segueName = segue.identifier{
            switch segueName{
            case "newMeal":
//                print("new meal")
                navigationType = .newMeal
                if let destinationController = segue.destination as? ViewController{
                    destinationController.navigationType = .newMeal
                }
                
            case "editMeal":
//                print("edit meal")
                 navigationType = .editMeal
                // Get the selected meal
                if let selectedIndexPathRow = tableView.indexPathForSelectedRow{
                    //Get the selected meal from data source
                    let meal = meals[selectedIndexPathRow.row]
                    if let destinationController = segue.destination as? ViewController{
                        destinationController.meal = meal
                        destinationController.navigationType = .editMeal
                    }
                }
            default:
                break
            }
        }
    }
    
    
    //Create unWind to return from MealDetailController
    @IBAction func unWindFromMealDetailController(segue:UIStoryboardSegue) {
        //print("Back from meal detail")
        
        //Get source controller (MealDetailController)
        if let sourceController =  segue.source as? ViewController {
            if let meal = sourceController.meal {
                //print("Ten mon an duoc truyen sang la: \(meal.mealName)")
                
                //Identifying update or add new meal
                
                switch navigationType{
                case .newMeal :
                    //Add the new meal into the datasource: meals
                    meals += [meal]
                    //Add the new meal into the table view
                    let indexPath = IndexPath(row: meals.count - 1, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    // Insert new meal into databse
                    let _ = dao.insertMeal( meal: meal )
                case .editMeal:
                    // Get the position of selected row
                    if let selectedIndexPathRow = tableView.indexPathForSelectedRow{
                        //Update to data source
                        meals[selectedIndexPathRow.row] = meal
                        // Reload the update meal to table view
                        tableView.reloadRows(at: [selectedIndexPathRow], with: .automatic)
                    }
                }
               
            }
        }
    }

}
