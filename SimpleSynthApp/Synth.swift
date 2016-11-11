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
    
    
    
    init(){
        avEngine = AVAudioEngine()
        avPlayNode = AVAudioPlayerNode()
        avBuffer = AVAudioPCMBuffer(PCMFormat: avPlayNode.outputFormatForBus(0), frameCapacity: 100)
        avBuffer.frameLength = 100
        avMix = avEngine.mainMixerNode
        frequency = 261.6 // default to middle c
        sRate = 44100 // 44.1khz is a pretty standard sampling rate
        keyPressed = false
        
        for(var i = 0; i<100; ++i){
            let bufferFill = sinf((Float(i)*Float(M_PI*2)*frequency)/sRate)
            avBuffer.floatChannelData.memory[i] = bufferFill
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
        for(var i = 0; i<100; ++i){
            let bufferFill = sinf((Float(i)*Float(M_PI*2)*frequency)/sRate) //create a sine wave to fill the buffer
            avBuffer.floatChannelData.memory[i] = bufferFill
        }
        avPlayNode.scheduleBuffer(avBuffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops, completionHandler: nil)
        self.avPlayNode.play()
    }
    
    
    
    //pause audio output
    func pausePlayer(){
        self.avPlayNode.pause()
    }
    
}