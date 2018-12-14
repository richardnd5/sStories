import AudioKit

class SoundClass {

    let midi = AKMIDI()
    
    let windSound = AKMIDISampler()
    let touchDown = AKMIDISampler()
    let touchUp = AKMIDISampler()
    let pageTurnTouchDown = AKMIDISampler()
    let pageTurnTouchUp = AKMIDISampler()
    
    var pianoSampler = AKSampler()
    var currentPlaying = MIDINoteNumber()

    static var Sound = SoundClass()

    var currentTempo = 60.0 {
        didSet {
            sequencer.setTempo(currentTempo)
        }
    }
    
    var mixer = AKMixer()
    var filter = AKMoogLadder()
    var reverb = AKReverb()
    var sequencer = AKSequencer()
    
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

        filter = AKMoogLadder(windSound)
        filter.cutoffFrequency = 6000
        loadPianoSamples()

        mixer = AKMixer(windSound,touchDown,touchUp,pageTurnTouchUp,pageTurnTouchDown, pianoSampler)
        
        mixer.volume = 1.0

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
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("noodlePiano")
        pianoSampler.loadSFZ(path: (bundleURL?.path)!, fileName: "pianoNoodles.sfz")
        pianoSampler.releaseDuration = 2
    }
    
    func playPattern(){
        
        self.pianoSampler.stop(noteNumber: currentPlaying)
        let number = MIDINoteNumber.random(in: 0...36)
        currentPlaying = number
        pianoSampler.play(noteNumber: number, velocity: 127)
        
//        Timer.scheduledTimer(withTimeInterval: length, repeats: false, block:{_ in self.pianoSampler.stop(noteNumber: number)
//        })
        
        
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
