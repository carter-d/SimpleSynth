//
//  FirstViewController.swift
//  SimpleSynth
//
//  Created by Labuser on 11/15/16.
//  Copyright © 2016 wustl. All rights reserved.
//

//poster designed by Freepik
//<a href="http://www.freepik.com/free-photos-vectors/poster">Poster vector designed by Freepik</a>

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        IntroButton.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
//        pianoLabel.frame = IntroButton.bounds
//        view.addSubview(IntroButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var IntroButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 10, width: 200, height: 200)
        button.backgroundColor = UIColor.grayColor()
        button.layer.cornerRadius = 100
        return button
    }()
    
    private let pianoLabel: UILabel = {
        let label = UILabel()
        label.text = "SimpleSynth"
        label.textColor = UIColor.whiteColor()
        label.shadowColor = UIColor.blackColor()
        label.shadowOffset = CGSize(width:0, height: 0)
        
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(30)
        return label
    }()


}

