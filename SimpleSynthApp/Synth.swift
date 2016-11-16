//
//  Synth.swift
//  SimpleSynth
//
//
// The following class provides the core functionality for the synthesizer, generating and playing a waveform. Currently only sine waves are available - other wave forms will be added in the future.
// The project is currently still early in development and likely has a number of bugs
//
// The basic code for setting up the engine/buffer/mixer/player is adapted from the following sources:
// http://www.tmroyal.com/playing-sounds-in-swift-audioengine.html
// http://hondrouthoughts.blogspot.com/2014/09/avfoundation-audio-with-swift-using.html
//
//

import AVFoundation

class Synth {

    var avEngine: AVAudioEngine
    var avPlayNode: AVAudioPlayerNode
    var avBuffer: AVAudioPCMBuffer
    var avMix: AVAudioMixerNode
    var frequency: Float
    var sRate: Float
    var keyPressed: Bool
    var fc: UInt32
    var bufferLength: Int
    
    
    
    init(){
        bufferLength = 2
        fc = 2
        avEngine = AVAudioEngine()
        avPlayNode = AVAudioPlayerNode()
        avBuffer = AVAudioPCMBuffer(PCMFormat: avPlayNode.outputFormatForBus(0), frameCapacity: fc)
        avBuffer.frameLength = UInt32(bufferLength)
        avMix = avEngine.mainMixerNode
        frequency = 261.6 // default to middle c
        sRate = 44100 // 44.1khz is a pretty standard sampling rate
        keyPressed = false
        
        for(var i = 0; i<bufferLength; ++i){
            let bufferFill = sinf((Float(i)*Float(M_PI*2)*frequency)/sRate)
            avBuffer.floatChannelData.memory[i] = bufferFill
            //print(bufferFill)
        }
        
        avEngine.attachNode(avPlayNode)
        avEngine.connect(avPlayNode, to: avMix, format: avMix.outputFormatForBus(0))

        
        do {
            try avEngine.start()
        } catch {
            print(error)
        }
        
    }
    
    
    
    //play a note with a sine wave
    func playSineWave(){
        for(var i = 0; i<bufferLength; ++i){
            let bufferFill = sinf((Float(i)*Float(M_PI*2)*frequency)/sRate) //create a sine wave to fill the buffer
            avBuffer.floatChannelData.memory[i] = bufferFill
              print(bufferFill)
        }
        avPlayNode.scheduleBuffer(avBuffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops, completionHandler: nil)
        self.avPlayNode.play()
    }
    
    //trying to see if synth can let oscillator handle wave generating duty
    func playSoundFromOsc(){
        let dummyInput: [Float] = [Float](count: bufferLength, repeatedValue: 0)
        var osc1 = Oscillator()
        osc1.inputWaveFormBuffer = dummyInput
        osc1.frequency = 261.6
        osc1.waveForm = BasicWaves.Sine
        var o1 = osc1.getOutput()
        var osc2 = Oscillator()
        osc2.inputWaveFormBuffer = o1
        osc2.frequency = 261.6*1.498 //5th
        osc2.waveForm = BasicWaves.Sine
        osc2.intensity = 0
        var o2 = osc2.getOutput()
        var osc3 = Oscillator()
        osc3.inputWaveFormBuffer = o2
        osc3.frequency = Float(NoteFrequency.getFrequency(11)) //maj7th
        osc3.waveForm = BasicWaves.Sine
        osc2.intensity = 0
        
        var out = osc3.getOutput()
        for(var i = 0; i<bufferLength; ++i){
            avBuffer.floatChannelData.memory[i] = out[i]
        }
        avPlayNode.scheduleBuffer(avBuffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops, completionHandler: nil)
        self.avPlayNode.play()
    }
    
    
    //pause audio output
    func pausePlayer(){
        self.avPlayNode.pause()
    }
    
}