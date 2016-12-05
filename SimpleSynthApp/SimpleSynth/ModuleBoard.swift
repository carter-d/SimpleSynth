//
//  ModuleBoard.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//This class is where we will accumulate all of the modules and "stack" all of the modules's get output method to get our final function

import Foundation

class ModuleBoard {
    var inputFrequency: Float = 261.1
    var currentFrequency: Float = 261.1
    var indexOfLastKeyPress: Int = 0
    var theBoard: [SoundModule] = [SoundModule]()
     private let queue :dispatch_queue_t = dispatch_queue_create("SynthQueue", DISPATCH_QUEUE_SERIAL)
    init(){
//        let defaultOsc = Oscillator()
//        theBoard.append(defaultOsc)
    }
    func getOverallSound(index: Int) -> Float{
        if (inputFrequency != currentFrequency){
         //   dispatch_async(queue){
               self.syncParametersToUserInput()
          //  }
            currentFrequency = inputFrequency
        }
        var result: Float = 0
        for m in theBoard{
            result = m.getOutput(result, index: index)
        }
        return result
    }
    
    //this method is in charge of making sure that the user's input through the keyboard get updated for all of the modules and the modules' controller modules
    func syncParametersToUserInput(){
            for  m in theBoard{
                if m is Oscillator{
                    var stack: [Oscillator] = [Oscillator]()
                    stack.append(m as! Oscillator)
                    while (!stack.isEmpty){
                        let tempOsc = stack.popLast()
                        tempOsc!.updateInputParameter(inputFrequency)
                        if(tempOsc!.frequencyController != nil){
                            stack.append(tempOsc!.frequencyController as! Oscillator)
                        }
                        if(tempOsc!.intensityController != nil){
                            stack.append(tempOsc!.intensityController as! Oscillator)
                        }
                    }
                    
                }
                else if m is EnvGenerator{
                    m.updateInputParameter(Float(indexOfLastKeyPress))
                    print(indexOfLastKeyPress)
                }
            }
    }
}
