//
//  EnvGenerator.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import Foundation
class EnvGenerator: SoundModule{
    //Attack, Decay, Sustain, and Release are in units of ms
    //SustainLevel is in unit of gain, 1 being unity gain
    var attack: Int = 0
    var decay: Int = 1000
    var sustain: Int = 2000
    var sustainLevel: Float = 0.5
    var release: Int = 2000
    var indexOfLastTrigger: Int = -1000000
    
    override func getOutput(inputValue: Float,index: Int)->Float{
        var output: Float = inputValue
        let indexSinceLastTrigger = index - indexOfLastTrigger
        if (indexSinceLastTrigger < attack*Int(samplingRate)/1000){
          output = output*Float(indexSinceLastTrigger / (attack*Int(samplingRate)/1000))
           
        }
        else if (indexSinceLastTrigger < (attack+decay)*Int(samplingRate)/1000){
            //let Float(indexSinceLastTrigger - attack*Int(samplingRate)/1000)
            //output = output*Float((Float(indexSinceLastTrigger - attack*Int(samplingRate)/1000))/(decay*Int(samplingRate)/1000))
        }
        else if (indexSinceLastTrigger < (attack+decay+sustain)*Int(samplingRate)/1000){
            
        }
        else if (indexSinceLastTrigger < (attack+decay+sustain+release)*Int(samplingRate)/1000){
            
        }
        else {
            output = 0
        }
        
       return output
    }
    
    override func updateInputParameter(input: Float){
        indexOfLastTrigger = Int(input)
    }
}