//
//  BubbleView.swift
//  ARKit+CoreLocation
//
//  Created by Dzionis Brek on 1/9/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class BubbleView: UIView {

    @IBOutlet var bubbleView: UIView!
    @IBOutlet var placeText: UILabel!
    @IBOutlet var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bubbleView.layer.cornerRadius = bubbleView.layer.bounds.height / 2
    }
}
