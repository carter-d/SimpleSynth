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
    override func viewDidLoad() {
        super.viewDidLoad()
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
        newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    
    @IBAction func playDivineSound(sender: UIButton) {
         var newMB = ModuleBoard()
        var osc = Oscillator()
        var osc2 = Oscillator()
         var osc3 = Oscillator()
        var osc4 = Oscillator()
        osc.isTiedToKBInput = true
        osc2.isTiedToKBInput = true
        osc2.isTiedToKBInput = true
        osc3.isTiedToKBInput = true
        osc4.isTiedToKBInput = true
        osc2.stepsFromUserInput = 4
        osc3.stepsFromUserInput = 7
        osc4.stepsFromUserInput = 11
        osc2.intensity = 0.5
        osc3.intensity = 0.7
        osc4.intensity = 0.3
        
        newMB.theBoard.append(osc)
          newMB.theBoard.append(osc2)
          newMB.theBoard.append(osc3)
          newMB.theBoard.append(osc4)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()

        
    }
    @IBAction func playComplexWave(sender: UIButton) {
        var newMB = ModuleBoard()
        var osc = Oscillator()
        osc.isTiedToKBInput = true
        var intOsc = Oscillator()
        intOsc.waveForm = BasicWaves.Sine
        intOsc.frequency = 10
        osc.intensityController = intOsc
        
        var freqOsc = Oscillator()
        freqOsc.waveForm = BasicWaves.Triangle
        freqOsc.frequency = 0.5
        freqOsc.intensity = 5
        osc.frequencyController = freqOsc
        
        osc.waveForm = BasicWaves.Sawtooth
        newMB.theBoard.append(osc)
        exampleSynth.mb = newMB
        exampleSynth.playSoundFromModule()
    }
    
    @IBAction func frequencyAdjust(sender: UISlider) {
        exampleSynth.frequency = sender.value

    }
    
    
    @IBAction func stopNoise(sender: AnyObject) {
        exampleSynth.pausePlayer()
    }
    
    @IBAction func playNoisesIn5th(sender: AnyObject) {
            exampleSynth.playSoundFromModule()
    //FMSynthesizer.sharedSynth().play(440.0, modulatorFrequency: 679.0, modulatorAmplitude: 0.8)
    }
//   
//    func letsTrySerializing(mb:ModuleBoard){
//        let mbData = mb.
//        var sJson = NSJSONSerialization.JSONObjectWithData(mbData, options: .MutableContainers) as NSArray
//    }

}

