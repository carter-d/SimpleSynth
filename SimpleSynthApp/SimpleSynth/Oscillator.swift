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
    var inputWaveFormBuffer: [Float]? = nil
    var outputWaveFormBuffer: [Float]? = nil
    var waveForm: BasicWaves? = nil
    var samplingRate: Float = 44100
    var intensity: Float = 1
//    func setFrequency(freq: Float){
//        frequency = freq
//    }
//    func setInput(input: [Float]){
//        inputWaveFormBuffer = input
//    }
    func getOutput()->[Float]{
        
        if (frequency != nil && waveForm != nil && inputWaveFormBuffer != nil){
            outputWaveFormBuffer = [Float](count: inputWaveFormBuffer!.count, repeatedValue: 0)
            for i in 0...inputWaveFormBuffer!.count-1{
                var newWaveFill: Float = 0.0
                switch waveForm! {
                case BasicWaves.Sine:
                    newWaveFill = sinf((Float(i)*Float(M_PI*2)*frequency!)/samplingRate)*intensity
                break
                case BasicWaves.Square:
                break
                case BasicWaves.Sawtooth:
                break
                default:
                    break
                    
                }
                outputWaveFormBuffer![i] = inputWaveFormBuffer![i] + newWaveFill
            }
        }
        return outputWaveFormBuffer!
    }
}