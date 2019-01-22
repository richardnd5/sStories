import AudioKit

class Sound {
    
    static var sharedInstance = Sound()
    
    var mixer = AKMixer()
    private var reverb = AKReverb()
    private var sequencer = AKSequencer()
    private var patternArray = [MelodyAudio]()
    
    var pageTurnSoundArray = [PageTurnPianoPling]()
    
    var callbacker: AKCallbackInstrument!

    
    
    func setup(){
        
        mixer = AKMixer()
        mixer.volume = 2.0
        reverb = AKReverb(mixer, dryWetMix: 0.5)
        AudioKit.output = reverb
        do { try AudioKit.start() } catch { print("Couldn't start AudioKit. Here's Why: \(error)") }
        
        loadPageTurnSounds()
//        createCallbacker()
        
    }
//    func createCallbacker(){
//
//        callbacker = AKCallbackInstrument() { status, note, velocity in
//            if status == .noteOn {
//                print("worked")
//            }
//        }
//
//
//    }
    
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
//        let seqTrack = sequencer.newTrack("callbacker")
//        seqTrack?.setMIDIOutput(callbacker.midiIn)
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
        
//        let midiURL = Bundle.main.resourceURL?.appendingPathComponent("midi0.mid")
//        sequencer.addMIDIFileTracks(midiURL!, useExistingSequencerLength: true)
        
//        sequencer.tracks[sequencer.tracks.count-1].setMIDIOutput(callbacker.midiIn)
        
        
    }
    
    func playSequencer(){
        sequencer.rewind()
        sequencer.play()
    }
    
    

    func playPianoNote(_ note: Int){
        
        
        
    }

    func disconnectEverythingFromMixer(){
        do { try! AudioKit.stop() }
    }
    
}

