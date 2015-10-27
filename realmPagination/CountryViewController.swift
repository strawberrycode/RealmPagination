//
//  CountryViewController.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 26/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
    var country = Country()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (country != Country()) {
            label.text = "Welcome to \(country.name)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
