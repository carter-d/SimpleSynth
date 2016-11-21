//
//  FeedCellView.swift
//  SimpleSynth
//
//  Created by Estee Rebibo on 11/20/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import UIKit

class FeedCellView: UICollectionViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Poster: UIImageView!
    

    var synth: ModuleBoard?{
        didSet{
            updateUI()
        }
    }
    func updateUI(){
        Poster.image = UIImage(named: "play")
        Title.text = "Test Synth"
    }
 
}
