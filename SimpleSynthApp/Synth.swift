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
//We based the syntax and scheme of two concurrent buffers on: https://gist.github.com/rgcottrell/5b876d9c5eea4c9e411c
//

import AVFoundation

class Synth {

    var avEngine: AVAudioEngine
    var avPlayNode: AVAudioPlayerNode
    var avMix: AVAudioMixerNode
    var frequency: Float
    var sRate: Float
    var keyPressed: Bool
    let bufferLength: Int = 1024
    private let numberOfBuffers:Int = 2
    private var buffers =  [AVAudioPCMBuffer]()
    let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2);
    
    private let queue :dispatch_queue_t = dispatch_queue_create("SynthQueue", DISPATCH_QUEUE_SERIAL)
    private let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(2)//couldn't use "numberOfBuffers" as input, strange

    
    init(){
        avEngine = AVAudioEngine()
        avPlayNode = AVAudioPlayerNode()
        for i in 0...numberOfBuffers - 1 {
        var avBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: UInt32(bufferLength))
             buffers.append(avBuffer)
        }
        avMix = avEngine.mainMixerNode
        frequency = 261.6 // default to middle c
        sRate = 44100 // 44.1khz is a pretty standard sampling rate
        keyPressed = false
        

        
        avEngine.attachNode(avPlayNode)
        avEngine.connect(avPlayNode, to: avMix, format: audioFormat)

        
        
    }
    
    func playSin(){
        dispatch_async(queue){
        var totalSampleIndex:Float = 0
        var currentBufferIndex = 0
            while true {
                var currentBuffer = self.buffers[currentBufferIndex]
                var leftChannelData = currentBuffer.floatChannelData[0]
                var rightChannelData = currentBuffer.floatChannelData[1]
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
                for sampleIndex in 0...self.bufferLength-1{
                    let sampleValue = sinf((Float(totalSampleIndex)*Float(M_PI*2)*self.frequency)/self.sRate) //create a sine wave to fill the buffer
                    leftChannelData[sampleIndex] = sampleValue
                    rightChannelData[sampleIndex] = sampleValue
                    totalSampleIndex = totalSampleIndex + 1
                   // print(sampleValue)
                 }
                currentBuffer.frameLength = UInt32(self.bufferLength)
                self.avPlayNode.scheduleBuffer(currentBuffer) {
                    dispatch_semaphore_signal(self.semaphore)
                    return
                }
                
             currentBufferIndex = (currentBufferIndex + 1) % self.numberOfBuffers
            }
        }
        do {
            try self.avEngine.start()
        }
        catch{
            print("can't start engine")
        }
      //  playerNode.pan = 0.8
        avPlayNode.play()

        
    }
    func playSoundFromModule(){

        dispatch_async(queue){
            var totalSampleIndex:Float = 0
            var currentBufferIndex = 0
            var osc1 = Oscillator()
            
            osc1.intensity = 1
            osc1.waveForm = BasicWaves.Sine
            var osc2 = Oscillator()
            
            osc2.intensity = 0
            osc2.waveForm = BasicWaves.Sine
            var osc3 = Oscillator()
            osc3.intensity = 10
            osc3.waveForm = BasicWaves.Sine
            
            while true {
                osc3.frequency = 0.5
               
                var currentBuffer = self.buffers[currentBufferIndex]
                var leftChannelData = currentBuffer.floatChannelData[0]
                var rightChannelData = currentBuffer.floatChannelData[1]
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
                for sampleIndex in 0...self.bufferLength-1{
                    osc1.frequency = osc3.getOutput(500, index: Int(totalSampleIndex))
                    // print(osc1.frequency)
                    osc2.frequency = NoteFrequency.getFrequency(osc1.frequency, stepsFromNote: 7)
                    let osc1value = osc1.getOutput(0, index: Int(totalSampleIndex)) //create a sine wave to fill the buffer
                    let sampleValue = osc2.getOutput(osc1value,index: Int(totalSampleIndex))
                    leftChannelData[sampleIndex] = sampleValue
                    rightChannelData[sampleIndex] = sampleValue
                    totalSampleIndex = totalSampleIndex + 1
                 //   print(sampleValue)
                }
                currentBuffer.frameLength = UInt32(self.bufferLength)
                self.avPlayNode.scheduleBuffer(currentBuffer) {
                    dispatch_semaphore_signal(self.semaphore)
                    return
                }
                
                currentBufferIndex = (currentBufferIndex + 1) % self.numberOfBuffers
            }
        }
        do {
            try self.avEngine.start()
        }
        catch{
            print("can't start engine")
        }
        //  playerNode.pan = 0.8
        avPlayNode.play()
        
        
    }

    
    //play a note with a sine wave
//    func playSineWave(){
//        for(var i = 0; i<bufferLength; ++i){
//            let bufferFill = sinf((Float(i)*Float(M_PI*2)*frequency)/sRate) //create a sine wave to fill the buffer
//            avBuffer.floatChannelData.memory[i] = bufferFill
//              print(bufferFill)
//        }
//        avPlayNode.scheduleBuffer(avBuffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops, completionHandler: nil)
//        self.avPlayNode.play()
//    }
//    
//    //trying to see if synth can let oscillator handle wave generating duty
//    func playSoundFromOsc(){
//        let dummyInput: [Float] = [Float](count: bufferLength, repeatedValue: 0)
//        var osc1 = Oscillator()
//        osc1.inputWaveFormBuffer = dummyInput
//        osc1.frequency = 261.6
//        osc1.waveForm = BasicWaves.Sine
//        var o1 = osc1.getOutput()
//        var osc2 = Oscillator()
//        osc2.inputWaveFormBuffer = o1
//        osc2.frequency = 261.6*1.498 //5th
//        osc2.waveForm = BasicWaves.Sine
//        osc2.intensity = 0
//        var o2 = osc2.getOutput()
//        var osc3 = Oscillator()
//        osc3.inputWaveFormBuffer = o2
//        osc3.frequency = Float(NoteFrequency.getFrequency(11)) //maj7th
//        osc3.waveForm = BasicWaves.Sine
//        osc2.intensity = 0
//        
//        var out = osc3.getOutput()
//        for(var i = 0; i<bufferLength; ++i){
//            avBuffer.floatChannelData.memory[i] = out[i]
//        }
//        avPlayNode.scheduleBuffer(avBuffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Loops, completionHandler: nil)
//        self.avPlayNode.play()
//    }
//    
//    
    //pause audio output
    func pausePlayer(){
        self.avPlayNode.pause()
    }
    
}