import AudioKit

class SoundClass {

    let midi = AKMIDI()
    
    let backgroundPiano = AKMIDISampler()
    let touchDown = AKMIDISampler()
    let touchUp = AKMIDISampler()
    let pageTurnTouchDown = AKMIDISampler()
    let pageTurnTouchUp = AKMIDISampler()
    
    var pianoSampler = AKSampler()

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
    
    func setupSound(){

        do {
            try backgroundPiano.loadWav("backgroundPlaceholder")
            try touchDown.loadWav("touchDown")
            try touchUp.loadWav("touchUp")
            try pageTurnTouchDown.loadWav("pageTurnTouchDown")
            try pageTurnTouchUp.loadWav("pageTurnTouchUp")
            
            print("It did load the samples.")
        } catch {
            print("Error: Loading.")
            return
        }

        filter = AKMoogLadder(backgroundPiano)
        filter.cutoffFrequency = 8000
        loadPianoSamples()

        mixer = AKMixer(backgroundPiano,touchDown,touchUp,pageTurnTouchUp,pageTurnTouchDown, pianoSampler)
        
        mixer.volume = 6.0

        reverb = AKReverb(mixer)
        reverb.dryWetMix = 0.6
        AudioKit.output = reverb
        do { try AudioKit.start() }catch{}

        
        let track1 = sequencer.newTrack("New Track")

        track1?.setMIDIOutput(backgroundPiano.midiIn)
        sequencer.setTempo(currentTempo)
        startSequencer()
    }
    
    func loadPianoSamples() {
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("noodlePiano")
        pianoSampler.loadSFZ(path: (bundleURL?.path)!, fileName: "pianoNoodles.sfz")
        pianoSampler.releaseDuration = 0.1
    }
    
    func playPattern(){
        
        let number = MIDINoteNumber.random(in: 0...6)
        pianoSampler.play(noteNumber: number, velocity: 127)
        Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false, block:{_ in self.pianoSampler.stop(noteNumber: number)})
    }

    
    func startSequencer() {
        
        let seqLength = AKDuration(beats: Double(32))
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
