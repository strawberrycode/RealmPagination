//
//  CollectionViewCell.swift
//  realmPagination
//
//  Created by Catherine Schwartz on 25/10/2015.
//  Copyright © 2015 Catherine Schwartz. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
//    func configureCellForCountryAtIndexPath(country: Country, indexPath: NSIndexPath) {
//        
//        index.text = "\(indexPath.item)"
//        countryName.text = country.name
//        code.text = country.code
//    }
    
    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        let cellWidth = UIScreen.mainScreen().bounds.width / 2
        let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
//        let size = self.sizeThatFits(CGSize(width: attr.frame.size.width, height: CGFloat.max))
        attr.frame.size = CGSizeMake(cellWidth, cellWidth)
        return attr
        
//        let toReturn = layoutAttributes.copy() as! UICollectionViewLayoutAttributes //super.preferredLayoutAttributesFittingAttributes(layoutAttributes)
//        var newFrame = toReturn.frame
//        newFrame.size = CGSizeMake(cellWidth, cellWidth)
//        toReturn.size = newFrame.size
//        self.frame.size.height = toReturn.frame.size.height
//        return toReturn
    }
}

