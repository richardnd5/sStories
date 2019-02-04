import AudioKit

class AudioFile {
    
    private var audioFile : AKAudioFile!
    var sampler = AKMIDISampler()
    var randomIntervalTimer = Timer()

    var name : String!
    
    init(fileName: String) {
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
        Sound.sharedInstance.soundEffectMixer.connect(input: sampler)
    }
    
    func play(){
        do { try sampler.play(noteNumber: 60, velocity: 100, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
    }
    
    var firstTime = true
    func playRandomIntervalAndPitch(){
        if firstTime {
            firstTime = false
            do { try self.sampler.play(noteNumber: 67, velocity: 127, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
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



