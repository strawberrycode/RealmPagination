//
//  TableViewController.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 25/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    let realm = try! Realm()
    let translator = Translator()
    var notificationToken: NotificationToken?
    //    var countries = try! Realm().objects(Country).sorted("id")  // if used, no need to do the query in refreshData()
    var countries = Results<Country>?()
    
    let preloadMargin = 5
    var lastLoadedPage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // clean DB
        try! realm.write {
            self.realm.deleteAll()
        }
        
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.reloadData()
        }
        
        getData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Data stuff
    
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
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let countries = countries {
            return countries.count
        }
        return 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath)

        let nextPage: Int = Int(indexPath.row / pageSize) + 1
        //        print("nextPage: \(nextPage) - lastLoadedPage: \(lastLoadedPage)")
        //        print("indexPath.row: \(indexPath.row) - nextPage * pageSize - preloadMargin: \(nextPage * pageSize - preloadMargin)")
        
        if (indexPath.row >= (nextPage * pageSize - preloadMargin) && lastLoadedPage < nextPage) {
            print("get next page : \(nextPage)")
            getData(nextPage)
        }
        
        if let countries = countries {
            let country = countries[indexPath.row]
            cell.textLabel?.text = "\(country.id) - \(country.name)"
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
