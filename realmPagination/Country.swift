//
//  Country.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 24/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import Foundation
import RealmSwift

// countries.json source http://data.okfn.org/data/core/country-list

class Country: Object {

    dynamic var id = 0
    dynamic var name = ""
    dynamic var code = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}