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

class PianoViewController: UIViewController {
    @IBOutlet weak var cButton: KeyUIButton!
    @IBOutlet weak var cSharpButton: KeyUIButton!
    @IBOutlet weak var dButton: KeyUIButton!
    @IBOutlet weak var dSharpButton: KeyUIButton!
    @IBOutlet weak var eButton: KeyUIButton!
    @IBOutlet weak var fButton: KeyUIButton!
    @IBOutlet weak var fSharpButton: KeyUIButton!
    @IBOutlet weak var gButton: KeyUIButton!
    @IBOutlet weak var gSharpButton: KeyUIButton!
    @IBOutlet weak var aButton: KeyUIButton!
    @IBOutlet weak var aSharpButton: KeyUIButton!
    @IBOutlet weak var bButton: KeyUIButton!
    @IBOutlet weak var highCButton: KeyUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cButton.stepsAwayFromC = 0
        cSharpButton.stepsAwayFromC = 1
        dButton.stepsAwayFromC = 2
        dSharpButton.stepsAwayFromC = 3
        eButton.stepsAwayFromC = 4
        fButton.stepsAwayFromC = 5
        fSharpButton.stepsAwayFromC = 6
        gButton.stepsAwayFromC = 7
        gSharpButton.stepsAwayFromC = 8
        aButton.stepsAwayFromC = 9
        aSharpButton.stepsAwayFromC = 10
        bButton.stepsAwayFromC = 11
        highCButton.stepsAwayFromC = 12
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
    
    @IBAction func keyPressed(sender: KeyUIButton) {
      //  print(sender.stepsAwayFromC)
        exampleSynth.frequency = NoteFrequency.getFrequency(sender.stepsAwayFromC)
        exampleSynth.totalSampleIndex = 0
    //    exampleSynth.mb.indexOfLastKeyPress = exampleSynth.totalSampleIndex
    }
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

