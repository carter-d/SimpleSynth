//
//  ModuleBoard.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//This class is where we will accumulate all of the modules and "stack" all of the modules's get output method to get our final function

import Foundation

class ModuleBoard {
    var inputFrequency: Float? = 261.1
    var theBoard: [SoundModule] = [SoundModule]()
    init(){
        var masterOsc = Oscillator()
        theBoard.append(masterOsc)
    }
    func getOverallSound(index: Int) -> Float{        
        if (inputFrequency != nil){
            var mo = theBoard[0] as! Oscillator
            mo.frequency = inputFrequency!
        }
    
        var result: Float = 0
        for m in theBoard{
            result = m.getOutput(result, index: index)
        }
        return result
    }
}
