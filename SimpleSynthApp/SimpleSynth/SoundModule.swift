//
//  SoundModule.swift
//  SimpleSynth
//
//  Created by Ray on 11/16/16.
//  Copyright © 2016 SimpleSynth. All rights reserved.
//

import Foundation
class SoundModule: EVObject {
    var isTiedToKBInput: Bool = false
    var samplingRate: Float = 44100
    func getOutput(inputValue: Float,index: Int)->Float{
        return 0.0
    }
    func updateInputParameter(input: Float){
    }
}