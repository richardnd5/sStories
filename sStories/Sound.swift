import AudioKit

class Sound {
    
    static var sharedInstance = Sound()
    
    private var mainMixer = AKMixer()
    var pianoMixer = AKMixer()
    var soundEffectMixer = AKMixer()
    private var reverb = AKReverb()
    private var sequencer = AKSequencer()
    private var patternArray = [MelodyAudio]()
    var pageTurnSoundArray = [PageTurnPianoPling]()
    var pondBackground = PondAmbience()
    var pianoSampler = AKSampler()

    

    func setup(){

        soundEffectMixer.volume = 0.3
        reverb = AKReverb(pianoMixer, dryWetMix: 0.5)
        mainMixer = AKMixer(reverb, soundEffectMixer, pondBackground, pianoSampler)
        mainMixer.volume = 1.0
        
        AudioKit.output = mainMixer
        do { try AudioKit.start() } catch { print("Couldn't start AudioKit. Here's Why: \(error)") }
        
        loadPageTurnSounds()
        loadPianoSamples()
    }
    
    func loadPianoSamples() {
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("FrontPageKeyboard")
        pianoSampler.loadSFZ(path: (bundleURL?.path)!, fileName: "frontPagePianoKeyboard.sfz")
        pianoSampler.releaseDuration = 0.1
        
    }

    func loadPageTurnSounds(){
        
        for i in 0...8{
            let note = PageTurnPianoPling(number: i)
            pageTurnSoundArray.append(note)
        }
    }

    func loadCollectedMelodies(_ melodyArray: [Melody]){
        
        for i in 0...collectedMelodies.count-1{
          let melAudio = collectedMelodies[i].audio
            patternArray.append(melAudio!)
        }
    }
    
    func putMelodiesIntoSequencerInOrder(){
        setupSequencerTracks()
        createSequencerPattern()
    }
    
    private func setupSequencerTracks(){
        
        sequencer.setTempo(tempo)
        
        for i in 0...patternArray.count-1 {
            let melody = patternArray[i]
            let track = sequencer.newTrack("\(melody.number)")
            track?.setMIDIOutput(melody.sampler.midiIn)
            melody.trackNumber = i
        }
    }
    
    private func createSequencerPattern(){
        let seqLength = AKDuration(beats: 8*patternArray.count-1)
        sequencer.setLength(seqLength)
        
        for track in sequencer.tracks {
            track.clear()
        }
        
        for i in 0...patternArray.count-1 {
            sequencer.tracks[i].add(noteNumber: MIDINoteNumber(60),
                                    velocity: 127,
                                    position: AKDuration(beats: i*8),
                                    duration: AKDuration(beats: 18))
        }
    }
    
    func loadMelodyIntoSampler(){
        loadCollectedMelodies(collectedMelodies)
        putMelodiesIntoSequencerInOrder()
    }
    
    func playPondBackground(){
        pondBackground.playLoop()
    }
    
    func stopPondBackground(){
        pondBackground.stopLoop()
    }
    
    func turnDownPond(){
        pondBackground.turnDownSound()
    }
    
    func turnUpPond(){
        pondBackground.turnUpSound()
    }
    
    func playSequencer(){
        sequencer.rewind()
        sequencer.play()
    }
    
    func playNote(_ note: MIDINoteNumber){
        pianoSampler.play(noteNumber: note, velocity: 127)
    }
    
    func stopNote(_ note: MIDINoteNumber){
        pianoSampler.stop(noteNumber: note)
    }
    
}

