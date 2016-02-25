//
//  DictionaryDetailViewController.swift
//  MyDictionary
//
//  Created by Nicolegs on 11/5/15.
//  Copyright © 2016 nicolegs. All rights reserved.
//

import UIKit

class DictionaryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView:UITableView!
    
    var dictionary:Dictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title do Navigation Controller.
        title = dictionary.word
        
        //line separators
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Self sizing
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as!  DictionaryDetailTableViewCell
        
        // Configure the cell...
        switch indexPath.row {
        case 0:
            cell.typeLabel.text = dictionary.type
        default:
            cell.typeLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}
