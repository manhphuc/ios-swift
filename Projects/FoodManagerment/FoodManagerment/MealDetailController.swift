//
//  ViewController.swift
//  FoodManagerment
//
//  Created by CNTT on 4/8/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    
    @IBOutlet weak var btnGoToMap: UIButton!
    @IBOutlet weak var edtMealName: UITextField!
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var ratingControl: RatingControl!
    
    //Variable to pass to meal list controller
    var meal:Meal?
    
    enum NavigationType {
        case newMeal
        case editMeal
    }
    
    var navigationType:NavigationType = .newMeal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Settup for the button corner
        btnGoToMap.clipsToBounds = true
        btnGoToMap.layer.cornerRadius = 10
        //Delegation of TextFiel
        edtMealName.delegate = self
        
        //Get edit meal from meal table view controller
        if let meal = meal{
            // Set the meal into the layout
            navigationItem.title = meal.mealName
            edtMealName.text = meal.mealName
            imgMeal.image = meal.mealImage
            ratingControl.setratingValue(ratingValue: meal.ratingValue)
        }
    }
    //MARK: TextFiel 's Delegation Functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the Keyboard
        edtMealName.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("Ten cua mon an moi nhap la : \(edtMealName.text!)")
        navigationItem.title = edtMealName.text!
    }
    //MARK: Image processing
    @IBAction func ImageProcessing(_ sender: UITapGestureRecognizer) {
        //Hide the Keyboard
        edtMealName.resignFirstResponder()
        //Create an object of UIImagePickerController
        let imagePickerController = UIImagePickerController()
        //Settup the propertise for the image picker object
        imagePickerController.sourceType = .photoLibrary
        //Delegation of image picker controller
        imagePickerController.delegate = self
        //Pass to the image Picker controller Screen
        present(imagePickerController, animated: true, completion: nil)
    }
    //MARK: Image picker controller 's Delegation Function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Hide the image picker controller and return the previous screen
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage  {
            imgMeal.image = selectedImage
        }
        //Hide the image picker controller
        dismiss(animated: true, completion: nil)
    }
    //MARK: Navigation Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Identifying cancel new meal or cancel update meal
        switch navigationType {
        case .newMeal:
             dismiss(animated: true, completion: nil)
        case .editMeal:
            // Get the navigation controller
            if let navigationController = navigationController{
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //print("Chuyen man hinh")
        //Check if the sender is btnSave or not
        if let btnSender = sender as? UIBarButtonItem {
            if btnSave == btnSender {
                //print("Dung la button Save")
                let name = edtMealName.text ?? ""
                let image = imgMeal.image
                let ratingValue = ratingControl.getratingValue()
                
                //Create the neal meal
                meal = Meal(mealName: name, ratingValue: ratingValue, mealImage: image)
                
            }
        }
        //Check if the sender is btnGotoMap or not
        if let btnSender = sender as? UIButton {
            if btnGoToMap == btnSender {
                print("btnGoToMap is pressed!!")
            }
        }
    }
}

