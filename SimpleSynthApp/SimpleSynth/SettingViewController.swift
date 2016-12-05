//
//  ViewController.swift
//  SimpleSynth
//
//  Created by Carter Durno on 11/11/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import UIKit

var exampleSynth = Synth()

class SettingViewController: UIViewController {

    
    var mb = ModuleBoard()
    var baseOsc = Oscillator()
    var freqOsc = Oscillator()
    var intOsc = Oscillator()
    
    @IBOutlet var baseButtons: [UIButton]!
    @IBOutlet var freqButtons: [UIButton]!
    @IBOutlet var intensityButtons: [UIButton]!
    let aestheticOrange = UIColor(red: 255/255, green: 152/255, blue: 0, alpha: 1);
    
   
    override func viewDidLoad() {
        
        for button in baseButtons{
            button.addTarget(self, action: #selector(SettingViewController.setBaseWave(_:)), forControlEvents: .TouchUpInside)
        }
        
        for button in freqButtons{
            button.addTarget(self, action: #selector(SettingViewController.setFreqWave(_:)), forControlEvents: .TouchUpInside)
        }
        
        for button in intensityButtons{
            button.addTarget(self, action: #selector(SettingViewController.setIntensityWave(_:)), forControlEvents: .TouchUpInside)
        }
        
        super.viewDidLoad()
        mb.theBoard.append(baseOsc)
        exampleSynth.mb = self.mb
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func annoyingNoise(sender: AnyObject) {
        exampleSynth.keyPressed = true
        exampleSynth.playSin()
        
    }
    @IBAction func playSine(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Sine
        newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    @IBAction func playTriangle(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Triangle
        newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    @IBAction func playSquare(sender: AnyObject) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Square
        newMB.theBoard.append(osc)
        var eg = EnvGenerator()
        eg.attack = 0
        eg.decay = 5000
        newMB.theBoard.append(eg)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    @IBAction func playSawtoothWave(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        osc.waveForm = BasicWaves.Sawtooth
       // newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    
    enum WaveFormType: Int {case Sine = 0, Triangle = 1, Square = 2, Sawtooth = 3, None = 4}
    
    func setBaseWave(sender: UIButton){
        
        //reset all buttons colors to give the illusion of toggle buttons
        for button in baseButtons{
            button.backgroundColor = UIColor.blackColor();
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //set the base wave form and change button colors
        switch(WaveFormType(rawValue: sender.tag)!){
        case .Sine:
            baseButtons[0].backgroundColor = aestheticOrange
            baseButtons[0].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Sine
     //       mb.theBoard.append(baseOsc)
            //exampleSynth.mb = mb
            exampleSynth.playSoundFromModule()
            
            
            
        case .Triangle:
            baseButtons[1].backgroundColor = aestheticOrange
            baseButtons[1].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Triangle
        //    mb.theBoard.append(baseOsc)
         //  exampleSynth.mb = mb
           exampleSynth.playSoundFromModule()
            
        case .Square:
            baseButtons[2].backgroundColor = aestheticOrange
            baseButtons[2].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Square
       //     mb.theBoard.append(baseOsc)
        //    exampleSynth.mb = mb
            exampleSynth.playSoundFromModule()
            
        case .Sawtooth:
            baseButtons[3].backgroundColor = aestheticOrange
            baseButtons[3].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.isTiedToKBInput = true
            baseOsc.waveForm = BasicWaves.Sawtooth
       //     mb.theBoard.append(baseOsc)
        //    exampleSynth.mb = mb
            exampleSynth.playSoundFromModule()
            print(exampleSynth.mb.theBoard.count)
        case .None:
            print("none")
        }
    }
    
    
    func setFreqWave(sender: UIButton){
        
        //reset all buttons colors to give the illusion of toggle buttons
        for button in freqButtons{
            button.backgroundColor = UIColor.blackColor();
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //set the base wave form and change button colors
        switch(WaveFormType(rawValue: sender.tag)!){
        case .Sine:
            freqButtons[0].backgroundColor = aestheticOrange
            freqButtons[0].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Sine
            freqOsc.frequency = 0.5
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .Triangle:
            freqButtons[1].backgroundColor = aestheticOrange
            freqButtons[1].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Triangle
            freqOsc.frequency = 0.5
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .Square:
            freqButtons[2].backgroundColor = aestheticOrange
            freqButtons[2].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Square
            freqOsc.frequency = 0.5
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .Sawtooth:
            freqButtons[3].backgroundColor = aestheticOrange
            freqButtons[3].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            freqOsc.waveForm = BasicWaves.Sawtooth
            freqOsc.frequency = 0.5
            freqOsc.intensity = 5
            baseOsc.frequencyController = freqOsc
            
        case .None:
            freqButtons[4].backgroundColor = aestheticOrange
            freqButtons[4].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.frequencyController = nil
        }
    
    }
    
    func setIntensityWave(sender: UIButton){
        
        //reset all buttons colors to give the illusion of toggle buttons
        for button in intensityButtons{
            button.backgroundColor = UIColor.blackColor();
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //set the base wave form and change button colors
        switch(WaveFormType(rawValue: sender.tag)!){
        case .Sine:
            intensityButtons[0].backgroundColor = aestheticOrange
            intensityButtons[0].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Sine
            intOsc.frequency = 0.5
            baseOsc.intensityController = intOsc
            
        case .Triangle:
            intensityButtons[1].backgroundColor = aestheticOrange
            intensityButtons[1].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Triangle
            intOsc.frequency = 0.5
            baseOsc.intensityController = intOsc
            
        case .Square:
            intensityButtons[2].backgroundColor = aestheticOrange
            intensityButtons[2].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Square
            intOsc.frequency = 0.5
            baseOsc.intensityController = intOsc
            
        case .Sawtooth:
            intensityButtons[3].backgroundColor = aestheticOrange
            intensityButtons[3].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            intOsc.waveForm = BasicWaves.Sawtooth
            intOsc.frequency = 0.5
            baseOsc.intensityController = intOsc
            
        case .None:
            intensityButtons[4].backgroundColor = aestheticOrange
            intensityButtons[4].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            baseOsc.intensityController = nil
        }
    
    }


//    @IBAction func annoyingNoise(sender: AnyObject) {
//        exampleSynth.keyPressed = true
//        exampleSynth.playSin()
//        
//    }
//    @IBAction func playSine(sender: UIButton) {
//        var newMB = ModuleBoard()
//        var osc = Oscillator()
//        osc.isTiedToKBInput = true
//        osc.waveForm = BasicWaves.Sine
//        newMB.theBoard.append(osc)
//        exampleSynth.mb = newMB
//        exampleSynth.playSoundFromModule()
//    }
//    @IBAction func playTriangle(sender: UIButton) {
//        var newMB = ModuleBoard()
//        var osc = Oscillator()
//        osc.isTiedToKBInput = true
//        osc.waveForm = BasicWaves.Triangle
//        newMB.theBoard.append(osc)
//        exampleSynth.mb = newMB
//        exampleSynth.playSoundFromModule()
//    }
//    @IBAction func playSquare(sender: AnyObject) {
//        var newMB = ModuleBoard()
//        var osc = Oscillator()
//        osc.isTiedToKBInput = true
//        osc.waveForm = BasicWaves.Square
//        newMB.theBoard.append(osc)
//        exampleSynth.mb = newMB
//        exampleSynth.playSoundFromModule()
//    }
//    @IBAction func playSawtoothWave(sender: UIButton) {
//        var newMB = ModuleBoard()
//        var osc = Oscillator()
//        osc.isTiedToKBInput = true
//        osc.waveForm = BasicWaves.Sawtooth
//        newMB.theBoard.append(osc)
//        exampleSynth.mb = newMB
//        exampleSynth.playSoundFromModule()
//    }
//    
//    @IBAction func playDivineSound(sender: UIButton) {
//         var newMB = ModuleBoard()
//        var osc = Oscillator()
//        var osc2 = Oscillator()
//         var osc3 = Oscillator()
//        var osc4 = Oscillator()
//        osc.isTiedToKBInput = true
//        osc2.isTiedToKBInput = true
//        osc2.isTiedToKBInput = true
//        osc3.isTiedToKBInput = true
//        osc4.isTiedToKBInput = true
//        osc2.stepsFromUserInput = 4
//        osc3.stepsFromUserInput = 7
//        osc4.stepsFromUserInput = 11
//        osc2.intensity = 0.5
//        osc3.intensity = 0.7
//        osc4.intensity = 0.3
//        
//        newMB.theBoard.append(osc)
//        newMB.theBoard.append(osc2)
//        newMB.theBoard.append(osc3)
//        newMB.theBoard.append(osc4)
//        exampleSynth.mb = newMB
//        exampleSynth.playSoundFromModule()
//
//        
//    }
//    @IBAction func playComplexWave(sender: UIButton) {
//        var newMB = ModuleBoard()
//        var osc = Oscillator()
//        osc.isTiedToKBInput = true
//        var intOsc = Oscillator()
//        intOsc.waveForm = BasicWaves.Sine
//        intOsc.frequency = 10
//        osc.intensityController = intOsc
//        
//        var freqOsc = Oscillator()
//        freqOsc.waveForm = BasicWaves.Triangle
//        freqOsc.frequency = 0.5
//        freqOsc.intensity = 5
//        osc.frequencyController = freqOsc
//        
//        osc.waveForm = BasicWaves.Sawtooth
//        newMB.theBoard.append(osc)
//        exampleSynth.mb = newMB
//        exampleSynth.playSoundFromModule()
//    }
//    
//    @IBAction func frequencyAdjust(sender: UISlider) {
//        exampleSynth.frequency = sender.value
//
//    }
//    
//    
//    @IBAction func stopNoise(sender: AnyObject) {
//        exampleSynth.pausePlayer()
//    }
//    
//    @IBAction func playNoisesIn5th(sender: AnyObject) {
//            exampleSynth.playSoundFromModule()
//    }
//
//    func letsTrySerializing(mb:ModuleBoard){
//        let mbData = mb.
//        var sJson = NSJSONSerialization.JSONObjectWithData(mbData, options: .MutableContainers) as NSArray
//    }

}

