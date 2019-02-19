import AudioKit

class OpeningMusic {
    
    private var audioFile : AKAudioFile!
    var sampler = AKMIDISampler()
    var randomIntervalTimer = Timer()
    
    var volume : Double!
    var firstTime = true
    
    init(volume: Double = 1.0) {
        self.volume = volume
        audioFile = loadAudioFile("openingMusic")
        setupSampler()
    }
    
    private func loadAudioFile(_ name: String) -> AKAudioFile{
        let path = Bundle.main.url(forResource: name, withExtension: "mp3")
        var file : AKAudioFile!
        do {
            try  file = AKAudioFile(forReading: path!)
        } catch {
            print("didn't load the audio file. Why? \(error)")
        }
        return file
    }
    
    func setupSampler(){
        do { try sampler.loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why:     \(error)") }
        sampler.enableMIDI()
        sampler.volume = volume
        Sound.sharedInstance.soundEffectMixer.connect(input: sampler)
    }
    
    func play(){
        do { try sampler.play(noteNumber: 60, velocity: 100, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
    }
    
    func playPitched(){
        let randomNote = MIDINoteNumber.random(in: 59...64)
        do { try sampler.play(noteNumber: randomNote, velocity: 120, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
    }
    
    var setInterval = Timer()
    var firstLoop = true
    
    func loop(){
        sampler.volume = volume
        if firstLoop {
            firstLoop = false
            do { try self.sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
        }
        let length = audioFile.duration
        setInterval = Timer.scheduledTimer(withTimeInterval: length, repeats: false, block: { _ in
            do { try self.sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
            self.loop()
        })
    }
    
    func loopOpeningMusic(){
        sampler.volume = volume
        if firstLoop {
            firstLoop = false
            do { try self.sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
        }
        let length = audioFile.duration-0.5
        setInterval = Timer.scheduledTimer(withTimeInterval: length, repeats: false, block: { _ in
            do { try self.sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
            self.loop()
        })
    }
    
    var fadeOutTimer = Timer()
    var fadeOutCounter = 100
    func stopLoop(){
        setInterval.invalidate()
        print("opening music stopping")
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.fadeOutCounter -= 1
            
            self.sampler.volume = self.fadeOutCounter/100
            
            if self.fadeOutCounter <= 0 {
                self.fadeOutTimer.invalidate()
                do { try self.sampler.stop(noteNumber: 60, channel: 1) } catch { print("couldn't stop the sampler. Why? \(error)")}
                self.firstLoop = true
                self.fadeOutCounter = 100
            }
        })
        
        
    }
    
    func stopReplaying(){
        randomIntervalTimer.invalidate()
        firstTime = true
    }
    
}



