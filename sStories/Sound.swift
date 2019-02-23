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
    
    var accompTrack : AKMusicTrack!
    var trackIV : AKMusicTrack!
    var trackV : AKMusicTrack!
    
    var trackImprov : AKMusicTrack!
    var trackAccompCallback : AKCallbackInstrument!
    var trackImprovCallback : AKCallbackInstrument!
    
    var chordIAudio : PianoAccompaniment!
    var chordIFadeCount = 0
    
    var chordIVAudio : PianoAccompaniment!
    var chordIVFadeCount = 0
    
    var chordVAudio : PianoAccompaniment!
    var chordVFadeCount = 0
    
    //    var openingMusic = OpeningMusic()
    
    func setup(){
        
        chordIAudio = PianoAccompaniment(name: "IChord")
        chordIVAudio = PianoAccompaniment(name: "IVChord")
        chordVAudio = PianoAccompaniment(name: "VChord")
        
        
        
        switchChord(chord: .I)
        chordIAudio.fadeOut()
        
        soundEffectMixer.volume = 0.3
        pianoMixer.volume = 1.0
        pianoSampler.masterVolume = 0.3
        
        reverb = AKReverb(pianoMixer, dryWetMix: 0.5)
        mainMixer = AKMixer(reverb, soundEffectMixer, pondBackground, pianoSampler)
        
        AudioKit.output = mainMixer
        do { try AudioKit.start() } catch { print("Couldn't start AudioKit. Here's Why: \(error)") }
        
        loadPageTurnSounds()
        loadPianoSamples()
        setupPlayZoneSequencer()
    }

    func switchChord(chord: ChordType){
        switch chord {
        case .I:
            chordIAudio.fadeIn()
            chordIVAudio.fadeOut()
            chordVAudio.fadeOut()
            
        case .IV:
            chordIAudio.fadeOut()
            chordIVAudio.fadeIn()
            chordVAudio.fadeOut()
        case .V:
            chordIAudio.fadeOut()
            chordIVAudio.fadeOut()
            chordVAudio.fadeIn()
        }
    }
    
    func playAccompaniment(){
        chordIAudio.playMelody()
        chordIVAudio.playMelody()
        chordVAudio.playMelody()
    }
    
    func setupPlayZoneSequencer(){
        
        trackAccompCallback = AKCallbackInstrument()
        trackAccompCallback.callback = sequencerCallback
        
        trackImprovCallback = AKCallbackInstrument()
        trackImprovCallback.callback = improvCallback
        
        accompTrack = playZoneSequencer.newTrack("accomp")
        trackImprov = playZoneSequencer.newTrack("improv")
        
        accompTrack.setMIDIOutput(trackAccompCallback.midiIn)
        trackImprov.setMIDIOutput(trackImprovCallback.midiIn)
        
        let seqLength = 100
        for i in 0...seqLength {
            accompTrack.add(midiNoteData: AKMIDINoteData(noteNumber: 60, velocity: 127, channel: 1, duration: playZoneSequenceLength, position: AKDuration(beats: i*8)))

        }

        playZoneSequencer.setTempo(tempo)
        playZoneSequencer.setLength(AKDuration(beats: 100*8))
        
    }
    
    
    func generatePianoImprov(notes: Array<MIDINoteNumber>, beats: Array<AKDuration>){
        for (i, note) in notes.enumerated() {
            
            let now = playZoneSequencer.nextQuantizedPosition(quantizationInBeats: 0.5).beats
            let beatTimePlusNow = beats[i].beats+now
            let newDuration = AKDuration(beats: beatTimePlusNow)
            let midiData = AKMIDINoteData(noteNumber: note, velocity: 127, channel: 1, duration: AKDuration(beats: 1), position: newDuration)
            
            trackImprov.add(midiNoteData: midiData)
        }
    }
    
    func removeMidiNotePattern(){
        
    }
    
    func startPlaySequencer(){
        playZoneSequencer.play()
    }
    
    func stopPlaySequencer(){
        playZoneSequencer.stop()
        playZoneSequencer.rewind()
        clearImprovTrack()
    }
    
    func clearImprovTrack(){
        trackImprov.clear()
    }
    
    func improvCallback(_ status: AKMIDIStatus,
                        _ noteNumber: MIDINoteNumber,
                        _ velocity: MIDIVelocity) {
        
        DispatchQueue.main.async {
            if status == .noteOn {
                self.pianoSampler.play(noteNumber: noteNumber, velocity: 60)
                print("sequencer position: \(self.playZoneSequencer.currentPosition.beats)")
                
                
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
                
                print("sequencer position: \(self.playZoneSequencer.currentPosition.beats)")
                
            } else if status == .noteOff {
                
            }
        }
    }
    
    func loadPianoSamples() {
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("FrontPageKeyboard")
        pianoSampler.loadSFZ(path: (bundleURL?.path)!, fileName: "frontPagePianoKeyboard.sfz")
        pianoSampler.releaseDuration = 7.0
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

