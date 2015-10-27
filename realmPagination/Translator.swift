//
//  Translator.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 24/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


let pageSize = 20

class Translator {
    
    let realm = try! Realm()
    
    
    
    func getJsonData() {
        
        if let file = NSBundle.mainBundle().pathForResource("countries", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: file) {
                let json = JSON(data: jsonData)

//                print(json)
                for (key,subJson):(String, JSON) in json {
                    //Do something you want
                    print("key: \(key) - subJson: \(subJson)")
                    if let name = subJson["name"].string {
                        print("-- name: \(name)")
                    }
                    let code = subJson["code"].stringValue
                    print("-- code: \(code)")

                }
            }
        }
    }


    func getPaginatedJsonData(skip: Int = 0, limit: Int = pageSize) -> [NSDictionary] {
        var countriesDict = [NSDictionary]()
        
        if let file = NSBundle.mainBundle().pathForResource("countries", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: file) {
                let json = JSON(data: jsonData)
                
                for (stringKey, subJson):(String, JSON) in json {
                    let key = Int(stringKey)!
                    
                    if (key >= skip && key < (skip + limit)) {
                        let name = subJson["Name"].stringValue
                        let code = subJson["Code"].stringValue
                        print("-- \(key) name: \(name) - code: \(code)")
                        countriesDict.append(["id": key, "name": name, "code": code])
                    }
                }
            }
        }
        return countriesDict
    }

    func getJsonDataForPage(page: Int = 0) -> [NSDictionary] {
        var countriesDict = [NSDictionary]()
        
        let skip = page * pageSize
        let limit = pageSize
        
        if let file = NSBundle.mainBundle().pathForResource("countries", ofType: "json") {
            if let jsonData = NSData(contentsOfFile: file) {
                let json = JSON(data: jsonData)
                
                for (stringKey, subJson):(String, JSON) in json {
                    let key = Int(stringKey)!
                    
                    if (key >= skip && key < (skip + limit)) {
                        let name = subJson["Name"].stringValue
                        let code = subJson["Code"].stringValue
//                        print("-- \(key) name: \(name) - code: \(code)")
                        countriesDict.append(["id": key, "name": name, "code": code])
                    }
                }
            }
        }
        return countriesDict
    }

    
    func saveCountries(countriesDict: [NSDictionary]) {
        
        try! realm.write {
            // Save one Venue object (and dependents) for each element of the array
            for country in countriesDict {
                self.realm.create(Country.self, value: country, update: true)
            }
        }
    }
    
    
}