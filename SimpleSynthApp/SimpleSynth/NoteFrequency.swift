//
//  NoteFrequency.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import Foundation
import UIKit

class NoteFrequency {
    static func getFrequency(stepsFromMiddleC: Int)->Float{
        return Float(261.6*pow(1.05946309436, Double(stepsFromMiddleC)))
       // 1.05946309436 is the 12th root of 2, which is the ratio between adjecent tones in equal temperament tuning.
    }
    static func getFrequency(noteFrequency: Float,stepsFromNote: Int)->Float{
        return Float(Double(noteFrequency)*pow(1.05946309436, Double(stepsFromNote)))
        // 1.05946309436 is the 12th root of 2, which is the ratio between adjecent tones in equal temperament tuning.
    }
}