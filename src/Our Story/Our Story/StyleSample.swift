//
//  styleSampleCell.swift
//  Our Story
//
//  Created by Christian S. on 29/06/15.
//  Copyright (c) 2015 mc2. All rights reserved.
//

import Foundation
import UIKit

class StyleSample: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "StyleSample"

    var image: UIImage = UIImage()
}