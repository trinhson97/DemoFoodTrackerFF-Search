//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController , UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        filterMeals = searchController.isActive ? (DataService.share.meals) : (DataService.share.meals.filter({ (meal) -> Bool in
//            return meal.name.lowercased().contains(searchController.searchBar.text!.lowercased())
//        }))
        filterMeals = DataService.share.meals.filter({ (meal000 : Meal) -> Bool in
            return meal000.name.lowercased().contains(searchController.searchBar.text!.lowercased())
            
        })
        tableView.reloadData()
    }

    let searchController = UISearchController(searchResultsController: nil)
    //MARK: Properties
    var filterMeals : [Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Data"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filterMeals.count
        } else {
            return DataService.share.meals.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell") as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell."
            )
        }
        let meals: Meal?
        searchController.isActive ? (meals = filterMeals[indexPath.row]) : (meals = DataService.share.meals[indexPath.row])
        cell.nameLabel.text = meals?.name
        cell.photoImageView.image = meals?.photo
        cell.ratingControl.rating = meals?.rating ?? 0
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if searchController.isActive {
                if let index = DataService.share.meals.index(of: filterMeals[indexPath.row]) {
                    DataService.share.meals.remove(at: index)
                    filterMeals.remove(at: indexPath.row)
                }
            } else {
                DataService.share.meals.remove(at: indexPath.row)
                filterMeals = DataService.share.meals
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mealViewController = segue.destination as? MealViewController else {return}
        if let index = tableView.indexPathForSelectedRow {
            if searchController.isActive {
                if let indexSend = DataService.share.meals.index(of: filterMeals[index.row]) {
                    mealViewController.index = indexSend
                }
            } else {
                mealViewController.index = index.row
            }
        }
    }
}

