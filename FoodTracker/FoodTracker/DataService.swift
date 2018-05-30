//
//  File.swift
//  FoodTracker
//
//  Created by Son on 5/30/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class DataService {
    static let share: DataService = DataService()
    private var _meals: [Meal]?
    var meals:  [Meal] {
        get {
            if _meals == nil {
                loadSampleMeals()
            }
            return _meals ?? []
        }
        set {
            _meals = newValue
        }
    }
    func loadSampleMeals() {
        _meals = []
        guard let meal1 = Meal(name: "Caprese Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 4) else {return}
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5) else {return}
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: #imageLiteral(resourceName: "meal3"), rating: 3) else {return}
        _meals = [meal1, meal2, meal3]
    }
    func insertNewMeal(meal: Meal) {
        _meals?.append(meal)
    }
}
