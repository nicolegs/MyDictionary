//
//  DictionaryTableViewController.swift
//  MyDictionary
//
//  Created by Nicolegs on 11/5/15.
//  Copyright © 2016 nicolegs. All rights reserved.
//

import UIKit
import CoreData

class DictionaryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating
{
    
    var searchController:UISearchController!
    var searchResults:[Dictionary] = []
    
    
    private var dictionaryItems:[Dictionary] = []
    
    private var cockpitDict = [String: [Dictionary]]()
    var sectionTitles = [String]()
    
    var fetchResultController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load menu items from database
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            let fetchRequest = NSFetchRequest(entityName: "DictionaryEntity")
            do {
                dictionaryItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Dictionary]
            } catch {
                print("Failed to retrieve record")
                print(error)
            }
        }
        
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search ..."
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            .Plain, target: nil, action: nil)
        
        // Enable self sizing cells
        tableView.estimatedRowHeight = 30.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        createCorkpitDict()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCorkpitDict() {
        
        for item in dictionaryItems {
            
            guard let word = item.word else {
                break
            }
            
            // Get the first letter of the word and build the dictionary
            let wordKey = word.substringToIndex(word.startIndex.advancedBy(1))
            if var cockpitItems = cockpitDict[wordKey] {
                cockpitItems.append(item)
                cockpitDict[wordKey] = cockpitItems
            } else {
                cockpitDict[wordKey] = [item]
            }
        }
        
        // Get the section titles from the dictionary's keys and sort them in ascending order
        sectionTitles = [String](cockpitDict.keys)
        sectionTitles = sectionTitles.sort({ $0 < $1 })
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active {
            return searchResults.count
        } else {
            // Return the number of rows in the section.
            let wordKey = sectionTitles[section]
            if let items = cockpitDict[wordKey] {
                return items.count
            }
            
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DictionaryTableViewCell
        
        let dictionary = (searchController.active) ? searchResults[indexPath.row]: dictionaryItems[indexPath.row]
        
        // Configure the cell...
        let wordKey = sectionTitles[indexPath.section]
        if let items = cockpitDict[wordKey] {
            cell.wordLabel.text = items[indexPath.row].word
            cell.definitionSmallLabel.text = items[indexPath.row].definition
        }
        
        
        //        cell.definitionSmallLabel.text = dictionary.definition
        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if searchController.active{
            return false
        }else{
            return true
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    
    // Mr Peyman tip:
    //    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
    //    return ["A", "C", "B"]
    //    }
    // Mr Peyman tip:
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "SECTION \(section+1)"
    //    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDictionaryDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! DictionaryDetailViewController
                destinationController.dictionary = (searchController.active) ? searchResults[indexPath.row] : dictionaryItems[indexPath.row]
                searchController.active = false
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController:
        UISearchController) {
            if let searchText = searchController.searchBar.text {
                filterContentForSearchText(searchText)
                tableView.reloadData()
            }
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = dictionaryItems.filter({ (dictionary:Dictionary) -> Bool in
            let wordMatch = dictionary.word!.rangeOfString(searchText, options:
                NSStringCompareOptions.CaseInsensitiveSearch)
            return wordMatch != nil
        })
    }    
}

