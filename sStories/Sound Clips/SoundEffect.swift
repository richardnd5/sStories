import AudioKit

class SoundEffect {
    
    private var audioFile : AKAudioFile!
    var sampler = AKMIDISampler()
    var randomIntervalTimer = Timer()

    var name : String!
    var volume : Double!
    var firstTime = true
    
    init(fileName: String, volume: Double = 1.0) {
        self.volume = volume
        audioFile = loadAudioFile("\(fileName)")
        setupSampler()
        self.name = fileName
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
    
    var fadeOutTimer = Timer()
    var fadeOutCounter = 100
    func stopLoop(){
        setInterval.invalidate()
        
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
    
    func playRandomIntervalAndPitch(){
        if firstTime {
            firstTime = false
            do { try self.sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
        }
        let randTimeInterval = TimeInterval.random(in: 0.3...0.6)
        randomIntervalTimer = Timer.scheduledTimer(withTimeInterval: randTimeInterval, repeats: false, block: { _ in
            let randomPitch = MIDINoteNumber.random(in: 54...70)
            let randVel = MIDIVelocity.random(in: 80...127)
            do { try self.sampler.play(noteNumber: randomPitch, velocity: randVel, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
            self.playRandomIntervalAndPitch()
        })
        
    }
    
    func stopReplaying(){
        randomIntervalTimer.invalidate()
        firstTime = true
    }

}



