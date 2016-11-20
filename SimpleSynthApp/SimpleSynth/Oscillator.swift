//
//  Oscillator.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import Foundation
import UIKit
class Oscillator: SoundModule{
    var frequency: Float = 0
    var waveForm: BasicWaves? = BasicWaves.Sine
    var samplingRate: Float = 44100
    var intensity: Float = 1
    var frequencyController: SoundModule? //an oscialltor's frequency can be controlled by another oscillator
    var intensityController: SoundModule? //an oscialltor's intensity can be controlled by another oscillator
    var baseFrequency: Float?
    var baseIntensity: Float?
    var stepsFromUserInput: Int = 0

    override func getOutput(inputValue: Float,index: Int)->Float{
        var outputWaveValue: Float = 0.0
        var freq = frequency
        var ints = self.intensity
        if(frequencyController != nil){
            if frequencyController is Oscillator{
                let freqOsc = frequencyController as! Oscillator
                freq = freqOsc.getOutput(self.frequency, index:index)
                }
            }
        if(intensityController != nil){
            if intensityController is Oscillator{
                let intsOsc = intensityController as! Oscillator
                ints = intsOsc.getOutput(self.intensity, index:index)
            }
            // intensity controller can also be env. gen.
        }
        
        switch waveForm! {
            case BasicWaves.Sine:
                outputWaveValue = inputValue + (sinf((Float(index)*Float(M_PI*2)*freq)/samplingRate)*ints)
               // print(freq)
            break
            case BasicWaves.Square:
                outputWaveValue = inputValue + (squaref((Float(index)*Float(M_PI*2)*freq)/samplingRate)*ints)
            break
            case BasicWaves.Sawtooth:
                outputWaveValue = inputValue + (sawtoothf((Float(index)*Float(M_PI*2)*freq)/samplingRate)*ints)
                break
        case BasicWaves.Triangle:
                outputWaveValue = inputValue + (trianglef((Float(index)*Float(M_PI*2)*freq)/samplingRate)*ints)
                break
        }
        
             return outputWaveValue
    }
    override func updateInputParameter(input: Float){
        if (isTiedToKBInput){
            frequency = NoteFrequency.getFrequency(input,stepsFromNote: stepsFromUserInput)
        }
    }


    private func squaref(x: Float)->Float{
        if (Double(x)%(M_PI*2) > M_PI){
            return 0.0
        }
        else {
          return 1.0
        }
    }
    private func sawtoothf(x: Float)->Float{
        let result = (-2/(M_PI)) * atan( ( 1/tan( (Double(x)*M_PI)/(M_PI*2)   ) )   );
        return Float(result);
    }
    
    private func trianglef(x: Float)->Float{
        let result = (2/(M_PI)) * asin( ( sin( (Double(x)*M_PI*2)/(M_PI*2)   ) )   );
        return Float(result);
        
    }

}