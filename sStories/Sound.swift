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
    
    var playZoneSequencer = AKSequencer()
    var playZoneSequenceLength = AKDuration(beats: 8.0)
    var trackAccomp : AKMusicTrack!
    var trackImprov : AKMusicTrack!
    var trackAccompCallback : AKCallbackInstrument!
    var trackImprovCallback : AKCallbackInstrument!
    
    var pianoAccompanimentAudio : PianoAccompaniment!
    
//    var openingMusic = OpeningMusic()

    func setup(){

        pianoAccompanimentAudio = PianoAccompaniment(name: "playOstinato")
        
        soundEffectMixer.volume = 0.3
        pianoMixer.volume = 0.8
        reverb = AKReverb(pianoMixer, dryWetMix: 0.5)
        mainMixer = AKMixer(reverb, soundEffectMixer, pondBackground, pianoSampler, pianoAccompanimentAudio.sampler)
        mainMixer.volume = 1.0
        
        AudioKit.output = mainMixer
        do { try AudioKit.start() } catch { print("Couldn't start AudioKit. Here's Why: \(error)") }
        
        loadPageTurnSounds()
        loadPianoSamples()
        setupPlayZoneSequencer()
    }
    
    func playAccompaniment(){
        pianoAccompanimentAudio.playMelody()
    }
    
    func setupPlayZoneSequencer(){
        
        trackAccompCallback = AKCallbackInstrument()
        trackAccompCallback.callback = sequencerCallback
        
        trackImprovCallback = AKCallbackInstrument()
        trackImprovCallback.callback = improvCallback
        
        trackAccomp = playZoneSequencer.newTrack("accomp")
        trackImprov = playZoneSequencer.newTrack("improv")
        
        trackAccomp.setMIDIOutput(trackAccompCallback.midiIn)
        trackImprov.setMIDIOutput(trackImprovCallback.midiIn)
        
        trackAccomp.add(midiNoteData: AKMIDINoteData(noteNumber: 60, velocity: 127, channel: 1, duration: playZoneSequenceLength, position: AKDuration(beats: 0)))
        
//        let length : Int = Int(playZoneSequenceLength.beats)
//        for i in 0..<length {
//            trackImprov.add(midiNoteData: AKMIDINoteData(noteNumber: 63, velocity: 70, channel: 1, duration: AKDuration(beats: 1), position: AKDuration(beats: Double(i))))
//        }
        
        playZoneSequencer.setTempo(tempo)
        playZoneSequencer.setLength(playZoneSequenceLength)
        playZoneSequencer.enableLooping()

    }
    
    func generatePianoImprov(notes: Array<MIDINoteNumber>, beats: Array<AKDuration>){
        for (i, note) in notes.enumerated() {
            
//            let now = playZoneSequencer.currentPosition.beats
//            let beat = AKDuration(beats: now+beats[i].beats)
            
            let midiData = AKMIDINoteData(noteNumber: note, velocity: 127, channel: 1, duration: AKDuration(beats: 8), position: beats[i])
            
            trackImprov.add(midiNoteData: midiData)
        }
    }
    
    func startPlaySequencer(){
        playZoneSequencer.play()
    }
    
    func stopPlaySequencer(){
        playZoneSequencer.stop()
        playZoneSequencer.rewind()
    }
    
    func improvCallback(_ status: AKMIDIStatus,
                           _ noteNumber: MIDINoteNumber,
                           _ velocity: MIDIVelocity) {
        
        DispatchQueue.main.async {
            if status == .noteOn {
                self.pianoSampler.play(noteNumber: noteNumber, velocity: velocity)
                
            } else if status == .noteOff {
                self.pianoSampler.stop(noteNumber: noteNumber)
            }
        }
    }
    
    
    func sequencerCallback(_ status: AKMIDIStatus,
                           _ noteNumber: MIDINoteNumber,
                           _ velocity: MIDIVelocity) {
        
        DispatchQueue.main.async {
            if status == .noteOn {
                self.playAccompaniment()
                
                
            } else if status == .noteOff {
 
            }
        }
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

