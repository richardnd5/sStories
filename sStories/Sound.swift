// Instead of loading all the sampels at once. What if you just loaded them when they were needed? You only need 6 at a time. You could save SO MUCH memory that way. Smart. On the to do list.

// AKSampler?

import AudioKit

class Sound {

    let midi = AKMIDI()
    
    let windSound = AKMIDISampler()
    let touchDown = AKMIDISampler()
    let touchUp = AKMIDISampler()
    let pageTurnTouchDown = AKMIDISampler()
    let pageTurnTouchUp = AKMIDISampler()
    
    var pianoSampler = AKSampler()
    var currentPlaying = MIDINoteNumber()

    static var sharedInstance = Sound()

    var currentTempo = 60.0 {
        didSet {
            sequencer.setTempo(currentTempo)
        }
    }
    
    var mixer = AKMixer()
    var filterForPiano = AKMoogLadder()
    var reverb = AKReverb()
    var sequencer = AKSequencer()
    var newFilter = AKLowPassFilter()
    var highCut = AKHighShelfFilter()
    
    var length : TimeInterval = 6.0
    
    func setupSound(){

        do {
            try windSound.loadWav("steadyBrownNoise")
            try touchDown.loadWav("touchDown")
            try touchUp.loadWav("touchUp")
            try pageTurnTouchDown.loadWav("pageTurnTouchDown")
            try pageTurnTouchUp.loadWav("pageTurnTouchUp")
            
            
            print("It did load the samples.")
        } catch {
            print("Error: Loading.")
            return
        }

        highCut = AKHighShelfFilter(pianoSampler, cutOffFrequency: 10000, gain: -20.0)
        
        loadPianoSamples()

        mixer = AKMixer(windSound,touchDown,touchUp,pageTurnTouchUp,pageTurnTouchDown,highCut)
        
        mixer.volume = 0.5

        reverb = AKReverb(mixer)
        reverb.dryWetMix = 0.6
        AudioKit.output = reverb
        do { try AudioKit.start() }catch{}

//        length = 32 * ((60*60) / Int(currentTempo))
        
        let track1 = sequencer.newTrack("New Track")

        track1?.setMIDIOutput(windSound.midiIn)
        sequencer.setTempo(currentTempo)
        startSequencer()
    }
    
    func loadPianoSamples() {
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("noodlePiano2")
        pianoSampler.loadSFZ(path: (bundleURL?.path)!, fileName: "pianoNoodles.sfz")
        pianoSampler.releaseDuration = 2
    }
    
    func playPattern(_ number: Int){
        
        self.pianoSampler.stop(noteNumber: currentPlaying)
        let number = MIDINoteNumber(number)
        currentPlaying = number
        pianoSampler.play(noteNumber: number, velocity: 100)

    }

    
    func startSequencer() {
        
        let seqLength = AKDuration(beats: Double(120))
        sequencer.setLength(seqLength)
        
        for track in sequencer.tracks {
            track.clear()
        }
        
        sequencer.tracks[0].add(noteNumber: MIDINoteNumber(60),
                                      velocity: 127,
                                      position: AKDuration(beats: 1),
                                      duration: AKDuration(beats: 32))
        
        sequencer.setLength(seqLength)
        sequencer.enableLooping()
        sequencer.play()
    }
    
    func playTouchDownSound(){
        do { try! touchDown.play(noteNumber: 60, velocity: 60, channel: 1)}
    }
    
    func playTouchUpSound(){
        do { try! touchUp.play(noteNumber: 60, velocity: 60, channel: 1)}
    }
    
    func playPageTurnDownSound(){
        do { try! pageTurnTouchDown.play(noteNumber: 60, velocity: 90, channel: 1)}
    }
    
    func playTurnUpSound(){
        do { try! pageTurnTouchUp.play(noteNumber: 60, velocity: 90, channel: 1)}
    }

}
