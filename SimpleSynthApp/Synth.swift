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
    var mb: ModuleBoard = ModuleBoard()
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

        
        setUpBoard()
    }
    
    //tempMethod before we have UI to set up moduleboard
    func setUpBoard(){
        var osc1 = Oscillator()
        osc1.frequency = NoteFrequency.getFrequency(frequency, stepsFromNote: 9)
        osc1.waveForm = BasicWaves.Square
        var osc2 = Oscillator()
        osc2.frequency = NoteFrequency.getFrequency(frequency, stepsFromNote: 2)
        osc2.waveForm = BasicWaves.Square
        mb.theBoard.append(osc1)
        mb.theBoard.append(osc2)
    }
    

    func playSoundFromModule(){
        dispatch_async(queue){
        var totalSampleIndex:Float = 0
        var currentBufferIndex = 0
        while true {
            let currentBuffer = self.buffers[currentBufferIndex]
            let leftChannelData = currentBuffer.floatChannelData[0]
            let rightChannelData = currentBuffer.floatChannelData[1]
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            for sampleIndex in 0...self.bufferLength-1{
                self.mb.inputFrequency = self.frequency
                let sampleValue = self.mb.getOverallSound(Int(totalSampleIndex))
                leftChannelData[sampleIndex] = sampleValue
                rightChannelData[sampleIndex] = sampleValue
                totalSampleIndex = totalSampleIndex + 1
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

//    func playTestSound(){
//
//        dispatch_async(queue){
//            var totalSampleIndex:Float = 0
//            var currentBufferIndex = 0
//            var osc1 = Oscillator()
//            
//            osc1.intensity = 1
//            osc1.waveForm = BasicWaves.Square
//            var osc2 = Oscillator()
//            
//            osc2.intensity = 1
//            osc2.waveForm = BasicWaves.Sine
//        //    var osc3 = Oscillator()
//      //      osc3.frequency = 0.1
//    //        osc3.intensity = 10
//          
//         //   osc1.frequencyController = osc3
//         //  osc1.intensityController = osc2
//         //   osc2.frequency = 1
//            
//            
//            while true {
//                let currentBuffer = self.buffers[currentBufferIndex]
//                let leftChannelData = currentBuffer.floatChannelData[0]
//                let rightChannelData = currentBuffer.floatChannelData[1]
//                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
//                for sampleIndex in 0...self.bufferLength-1{
//                    //osc2.frequency = NoteFrequency.getFrequency(osc1.frequency, stepsFromNote: 7)
//                    osc1.frequency = self.frequency
//                    osc2.frequency = NoteFrequency.getFrequency(self.frequency, stepsFromNote: 11)
//                    let sampleValue = osc2.getOutput(osc1.getOutput(0, index:Int(totalSampleIndex)),index: Int(totalSampleIndex))
//                    leftChannelData[sampleIndex] = sampleValue
//                    rightChannelData[sampleIndex] = sampleValue
//                   // print(sampleValue)
//                    totalSampleIndex = totalSampleIndex + 1
//                 //   print(sampleValue)
//                }
//                currentBuffer.frameLength = UInt32(self.bufferLength)
//                self.avPlayNode.scheduleBuffer(currentBuffer) {
//                    dispatch_semaphore_signal(self.semaphore)
//                    return
//                }
//                
//                currentBufferIndex = (currentBufferIndex + 1) % self.numberOfBuffers
//            }
//        }
//        do {
//            try self.avEngine.start()
//        }
//        catch{
//            print("can't start engine")
//        }
//        //  playerNode.pan = 0.8
//        avPlayNode.play()
//        
//        
//    }
//
    
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

    //pause audio output
    func pausePlayer(){
        self.avPlayNode.pause()
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
}