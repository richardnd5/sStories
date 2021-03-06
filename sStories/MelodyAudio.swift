import AudioKit

class MelodyAudio {
    
    private var audioFile : AKAudioFile?
    var sampler = AKMIDISampler()
    var number = Int()
    var trackNumber = Int()
    var isPlaying = false

    init(number: Int) {
        self.number = number
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
    
    private func setupSampler(){
        audioFile = loadAudioFile("melody\(number)")
        do { try sampler.loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why: \(error)") }
        sampler.enableMIDI()
        sampler.name = "\(number)"
        Sound.shared.pianoMixer.connect(input: sampler)
    }
    
    func playMelody(){
        isPlaying = true
        do { try sampler.play(noteNumber: 60, velocity: 127, channel: 1) } catch { print("couldn't play the melody. Why? Here: \(error)") }
    }
    
    func stopMelody(){
        isPlaying = false
        do { try sampler.stop(noteNumber: 60, channel: 1) } catch {}
    }
    
    func getAudioDuration() -> Double {
        return (audioFile?.duration)!
    }
}
