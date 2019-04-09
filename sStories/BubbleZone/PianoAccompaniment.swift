import AudioKit

class PianoAccompaniment {
    
    private var audioFile : AKAudioFile?
    var sampler = AKMIDISampler()
    var number = Int()
    var trackNumber = Int()
    var isPlaying = false
    var name : String!

    init(name: String) {
        self.name = name
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
        audioFile = loadAudioFile("\(name ?? "Melody0")")
        do { try sampler.loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why: \(error)") }
        sampler.enableMIDI()
        sampler.name = "\(number)"
        Sound.shared.pianoMixer.connect(input: sampler)
    }
    
    func playMelody(){
        isPlaying = true
        do { try sampler.play(noteNumber: 60, velocity: 70, channel: 1) } catch { print("couldn't play the melody. Why? Here: \(error)") }
    }
    
    func stopMelody(){
        isPlaying = false
        do { try sampler.stop(noteNumber: 60, channel: 1) } catch {}
    }
    
    private var max = 500
    private var counter = 500
    
    private var fadeTimer = Timer()
    private var fadeTime = 0.001
    
    func fadeIn(){
        self.fadeTimer.invalidate()
        
        if self.counter < max {
        fadeTimer = Timer.scheduledTimer(withTimeInterval: fadeTime, repeats: true, block: { _ in
            self.sampler.volume = Double(self.counter)/100
            self.counter += 2
            
            if self.counter >= self.max {
                self.counter = self.max
                self.fadeTimer.invalidate()
            }
        })
    }
    }
    
    func fadeOut(){
        self.fadeTimer.invalidate()
        
        if self.counter > 0 {
        fadeTimer = Timer.scheduledTimer(withTimeInterval: fadeTime, repeats: true, block: { _ in
            
            self.sampler.volume = Double(self.counter)/100
            self.counter -= 1
        
            if self.counter <= 0 {
                self.counter = 0
                self.fadeTimer.invalidate()
                
            }
            
        })
        }
    }
    
    
    
    func getAudioDuration() -> Double {
        return (audioFile?.duration)!
    }
}
