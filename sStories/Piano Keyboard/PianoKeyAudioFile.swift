import AudioKit

class PianoKeyAudioFile {
    
    private var audioFile : AKAudioFile?
    var sampler = AKMIDISampler()
    var number : Int!
    
    init() {
        
//        self.number = number
        audioFile = loadAudioFile("turnPiano8")
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
        Sound.shared.pianoMixer.connect(input: sampler)
    }
    
    func play(){
        do { try sampler.play(noteNumber: 60, velocity: 120, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
    }
    
    func stop(){
        do { try sampler.stop(noteNumber: 60, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
    }
    
    deinit {
        print("de initing")
    }
}


