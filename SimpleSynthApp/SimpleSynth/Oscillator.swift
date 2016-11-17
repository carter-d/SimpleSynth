//
//  Oscillator.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import Foundation
import UIKit
class Oscillator {
    var frequency: Float? = nil
  //  var inputWaveValue: Float = 0
  //  var outputWaveValue: Float = 0
    var waveForm: BasicWaves? = nil
    var samplingRate: Float = 44100
    var intensity: Float = 1
//    func setFrequency(freq: Float){
//        frequency = freq
//    }
//    func setInput(input: [Float]){
//        inputWaveFormBuffer = input
//    }
    func getOutput(inputValue: Float,index: Int)->Float{
        var outputWaveValue: Float = 0.0
        if (frequency != nil && waveForm != nil){
            
                switch waveForm! {
                case BasicWaves.Sine:
                    outputWaveValue = inputValue + (sinf((Float(index)*Float(M_PI*2)*frequency!)/samplingRate)*intensity)
                break
                case BasicWaves.Square:
                break
                case BasicWaves.Sawtooth:
                break
                default:
                    break
            }

       
        }
             return outputWaveValue
    }
}