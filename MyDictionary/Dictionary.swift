//
//  Dictionary.swift
//  MyDictionary
//
//  Created by Nicolegs on 11/5/15.
//  Copyright © 2016 nicolegs. All rights reserved.
//

import Foundation
import CoreData

class Dictionary: NSManagedObject {
    @NSManaged var word:String?
    @NSManaged var definition:String?
    @NSManaged var type:String?
    @NSManaged var year:String?
    @NSManaged var country:String?
    
}