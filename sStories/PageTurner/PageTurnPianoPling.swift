import AudioKit

class PageTurnPianoPling {
    
    private var audioFile : AKAudioFile?
    var sampler = AKMIDISampler()
    var number : Int!

    init(number: Int) {
        
        self.number = number
        audioFile = loadAudioFile("turnPiano\(number)")
        setupSampler()
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
    
    func setupSampler(){
        do { try sampler.loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why:     \(error)") }
        sampler.enableMIDI()
        Sound.sharedInstance.mixer.connect(input: sampler)
    }
    
    func playNote(){
        do { try sampler.play(noteNumber: 60, velocity: 70, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
        
    }
}

