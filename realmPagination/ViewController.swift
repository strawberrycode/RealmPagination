//
//  ViewController.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 23/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import UIKit
import RealmSwift



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let realm = try! Realm()
    let translator = Translator()
    var notificationToken: NotificationToken?
//    var countries = try! Realm().objects(Country).sorted("id")  // if used, no need to do the query in refreshData()
    var countries = Results<Country>?()
    
    let preloadMargin = 5
    var lastLoadedPage = 0
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // clean DB
        try! realm.write {
            self.realm.deleteAll()
        }
        
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.reloadData()
        }

        getData()
        
        print("-- Realm path --")
        print(realm.path)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(page: Int = 0) {
        lastLoadedPage = page
        let countriesToSave = translator.getJsonDataForPage(page)
        translator.saveCountries(countriesToSave)
    }
    

    func reloadData() {
        countries = realm.objects(Country).sorted("id")
//        print("savedCountries: \(countries)")

        self.tableView.reloadData()
    }
 
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return countries.count // use if countries = try! Realm().objects(Country).sorted("id") in init
        
        if let countries = countries {
            return countries.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nextPage: Int = Int(indexPath.row / pageSize) + 1
//        print("nextPage: \(nextPage) - lastLoadedPage: \(lastLoadedPage)")
//        print("indexPath.row: \(indexPath.row) - nextPage * pageSize - preloadMargin: \(nextPage * pageSize - preloadMargin)")

        if (indexPath.row >= (nextPage * pageSize - preloadMargin) && lastLoadedPage < nextPage) {
            print("get next page : \(nextPage)")
            getData(nextPage)
        }
        
        let cell = UITableViewCell()
        if let countries = countries {
            let country = countries[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row) - \(country.id) - \(country.name)"
        }
        
        return cell
    }
    
    
}

