//
//  Meal.swift
//  FoodManagerment
//
//  Created by CNTT on 4/29/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import UIKit

class Meal {
    //MARK: Properties
    var mealName : String = ""
    var ratingValue : Int = 0
    var mealImage : UIImage?
    
    //MARK: Constructors
    init? (mealName:String, ratingValue:Int, mealImage:UIImage?) {
        // Check the condirtions
        if mealName.isEmpty{
            return nil
        }
        if ratingValue < 0 || ratingValue > 5{
            return nil
        }
        self.mealName = mealName
        self.ratingValue = ratingValue
        self.mealImage = mealImage
    }
}
