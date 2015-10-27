//
//  CollectionViewController.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 25/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import UIKit
import RealmSwift


private let reuseIdentifier = "CollectionCell"

class CollectionViewController: UICollectionViewController {

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
         self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView!.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.

        if let cvl = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = UIScreen.mainScreen().bounds.width / 2
            cvl.estimatedItemSize = CGSize(width: cellWidth, height: cellWidth)
            cvl.minimumInteritemSpacing = 0
            cvl.minimumLineSpacing = 0
        }
        
        // clean DB
        try! realm.write {
            self.realm.deleteAll()
        }
        
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.reloadData()
        }
        
        getData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView?.layer.borderColor = UIColor.redColor().CGColor
        self.collectionView?.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Data stuff
    
    func getData(page: Int = 0) {
        lastLoadedPage = page
        let countriesToSave = translator.getJsonDataForPage(page)
//        print("countries - page: \(page) \n\(countriesToSave) \n----------")
        translator.saveCountries(countriesToSave)
    }
    
    func reloadData() {
        countries = realm.objects(Country).sorted("id")
//        print("savedCountries: \(countries)")
        
        collectionView?.reloadSections(NSIndexSet(index: 0))
//        self.collectionView?.reloadData()
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "showCountryDetails") {
            let cvc = segue.destinationViewController as! CountryViewController
            if let countries = self.countries,
                    tag = sender!.tag {
                cvc.country = countries[tag]
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let countries = countries {
            print("countries.count: \(countries.count)")
            return countries.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        
        // Configure the cell
        
        let nextPage: Int = Int(indexPath.item / pageSize) + 1
        let preloadIndex = nextPage * pageSize - preloadMargin
//        print("indexPath.row: \(indexPath.item) - nextPage: \(nextPage) - lastLoadedPage: \(lastLoadedPage) - preloadIndex: \(preloadIndex)")
        
        if (indexPath.item >= preloadIndex && lastLoadedPage < nextPage) {
            print("get next page : \(nextPage)")
            getData(nextPage)
        }
        
        if let countries = self.countries {
            let country = countries[indexPath.item] //as Country
//            cell.index!.text = "\(indexPath.item)"
//            cell.configureCellForCountryAtIndexPath(country, indexPath: indexPath)
            
            print("index: \(indexPath.item) - country: \(country.name) - \(country.code) - \(cell.frame)")
    
            cell.indexLabel.text = "\(indexPath.item)"
            cell.countryLabel.text = country.name
            cell.codeLabel.text = country.code
            cell.tag = indexPath.item
        }
        
        cell.setBorder(UIColor.blueColor())
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
