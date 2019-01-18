import AudioKit

class MelodyAudio {
    
    private var audioFile : AKAudioFile?
    var sampler = AKMIDISampler()
    var number = Int()
    var trackNumber = Int()
    
    
    
    init(number: Int) {
        
        self.number = number
        audioFile = loadAudioFile("melody\(number)")
        do { try sampler.loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why:     \(error)") }
        sampler.enableMIDI()
        sampler.name = "\(number)"
        
        Sound.sharedInstance.mixer.connect(input: sampler)
    }
    
    private func loadAudioFile(_ name: String)-> AKAudioFile{
        let path = Bundle.main.url(forResource: name, withExtension: "mp3")
        var file : AKAudioFile!
        do {
            try  file = AKAudioFile(forReading: path!)
        } catch {
            print("didn't load the audio file. Why? \(error)")
        }
        return file
    }
    
    func playMelody(){
        do { try sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the melody. Why? Here:  \(error)") }
    }
    
    deinit {
        // disconnect melody audio from mixer.
        print("deinit \(number)")
        
        //        sampler.disconnectOutput(from: Sound.sharedInstance.mixer)
        
    }
}
