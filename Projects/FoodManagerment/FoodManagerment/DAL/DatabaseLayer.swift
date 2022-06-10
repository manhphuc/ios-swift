//
//  DatabaseLayer.swift
//  FoodManagerment
//
//  Created by CNTT on 5/19/22.
//  Copyright © 2022 fit.tdc. All rights reserved.
//

import Foundation
import UIKit
import os.log

class DatabaseLayer{
    //MARK: Database's Properties
    private let DB_NAME = "meals.sqlite"
    private let DB_PATH: String?
    private let DB : FMDatabase?
    
    //MARK: Tables's Properties
    // 1. Table meals
    private let MEAL_TABLE_NAME = "meals"
    private let MEAL_ID = "_id"
    private let MEAL_NAME = "name"
    private let MEAL_IMAGE = "image"
    private let MEAL_RATING = "rating"
    
    //MARK: Constructors
    init() {
        //Get the directories to save database
        let directories:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        DB_PATH = directories[0] + "/" + DB_NAME
        
        //Initialization of Database
        DB = FMDatabase(path: DB_PATH)
        if DB != nil{
            os_log("The Database is created successful!")
            
            // Tables Creation
            tablesCreation()
        }
        else{
            os_log("The Database is not created successful!")
        }
    }
    
    //////////////////////////////////////////////////
    // MARK: Database 's Primities Definition
    /////////////////////////////////////////////////
    
    // open our database
    private func open() -> Bool {
        var OK = false
        
        if let DB = DB {
            if DB.open() {
                os_log( "The database is opened successful!" )
                OK = true
            } else {
                os_log( "The database is not opened successful!" )
            }
        } else {
            os_log( "The database is nil" )
        }
        
        return OK
    }
    
    // Close our database
    private func close() {
        if let DB = DB {
            DB.close()
        }
    }
    
    // 3. Tables Creation
    private func tablesCreation() {
        if open() {
            // Creation of SQL Statement
            let sql = "CREATE TABLE " + MEAL_TABLE_NAME + "("
            + MEAL_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
            + MEAL_NAME + " TEXT, "
            + MEAL_IMAGE + " TEXT, "
            + MEAL_RATING + "  INTEGER)"
            
            // Excute the SQL Statement
            if DB!.executeStatements( sql ) {
                os_log( "The tables are created successful!" )
            } else {
                os_log( "The tables are not created successful!" )
            }
        }
    }
    
    /////////////////////////////////////////////////
    // MARK: Database 's APIs Definition
    /////////////////////////////////////////////////
    
    // 1. Insert a meal into database
    public func insertMeal( meal: Meal ) -> Bool {
        var OK = false
        
        if open() {
            // Check if the table exist or not
            if DB!.tableExists( MEAL_TABLE_NAME ) {
                // 1. SQL Statemen creation
                let sql = "INSERT INTO \(MEAL_TABLE_NAME) (\(MEAL_NAME), \(MEAL_IMAGE), \(MEAL_RATING)) VALUES (?, ?, ?)"
                
                // 2. SQL Statement Execute
                // 2.1 Transform the meal image to string
                var stringImage = ""
                if let image = meal.mealImage {
                    // Step 1: UIImage => NSData
                    let imageNSData = image.pngData()! as NSData
                    // Step 2: NSData => String
                    stringImage = imageNSData.base64EncodedString( options: .lineLength64Characters )
                }
                
                if DB!.executeUpdate( sql, withArgumentsIn: [ meal.mealName, stringImage, meal.ratingValue ]) {
                    OK = true
                    os_log( "The meal is insert successful in the database!" )
                } else {
                    os_log( "The meal is not insert successful in the database!" )
                }
                close()
            }
        }
        return OK
    }
    
    // 2. Read meals from database
    public func readMeals( meals: inout [Meal] ){
        if open() {
            if DB!.tableExists( MEAL_TABLE_NAME ) {
                // 1. SQL Statement Creation
                let sql = "SELECT * FROM \(MEAL_TABLE_NAME) ODER BY \(MEAL_RATING) DESC"
                
                // 2. Execute the SQL Statement
                var result:FMResultSet? = nil
                do {
                    result = try DB!.executeQuery( sql, values: nil )
                }
                catch {
                    os_log( "Can not read the meals form database" )
                }
                
                // Read the meals from result to meals array
                if let result = result {
                    while ( result.next() ) {
                        let name = result.string( forColumn: MEAL_NAME ) ?? ""
                        let stringImage = result.string( forColumn: MEAL_IMAGE )
                        let rating = result.int( forColumn: MEAL_RATING )
                        
                        // Transform string image to UIImage
                        var image:UIImage? = nil
                        if let stringImage = stringImage {
                            if !stringImage.isEmpty {
                                // Step 1: stringImage => Data
                                let imageData = Data( base64Encoded: stringImage, options: .ignoreUnknownCharacters )!
                                
                                // Step 2: imageData => UIImage
                                image = UIImage( data: imageData )
                            }
                        }
                        let meal = Meal( mealName: name, ratingValue: Int( rating ), mealImage: image )!
                        meals.append( meal )
                    }
                }
            }
        }
    }
}
