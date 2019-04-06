import AudioKit

class VoiceOverAudio {
    
    private var audioFile : AKAudioFile!
    private var player : AKPlayer!
    var name : String!
    weak var delegate : SceneDelegate?
    
    static var shared = VoiceOverAudio(fileName: "readStory\(TempletonViewController.mainStoryLinePosition)")
    
    init(fileName: String) {
        audioFile = loadAudioFile("\(fileName)")
        setupPlayer()
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
    
    private func setupPlayer(){
        
        player = AKPlayer(audioFile: audioFile)
        player.connect(to: Sound.shared.soundEffectMixer)
        player.completionHandler = finishedCallback
    }
    
    private func finishedCallback(){
        delegate?.finishedReadingCallback()
    }
    
    func play(){
        if player.isPlaying {
            player.stop()
        }
        player.play()
    }
    
    func playWithDelay(time: TimeInterval = 0.3){
        Timer.scheduledTimer(withTimeInterval: time, repeats: false, block:{_ in
            self.play()
        })
    }
    
    func stop(){
        if player.isPlaying {
            player.stop()
        }
    }
    
    func enableLooping(){
        // Need to enable buffering if going to loop without pause.
        player.isLooping = true
    }
    
    func changeAudioFile(to file: String){
        print("changed audio file")
        disconnect()
        audioFile = loadAudioFile(file)
        player = AKPlayer(audioFile: audioFile)
        player.connect(to: Sound.shared.soundEffectMixer)
        player.completionHandler = finishedCallback
        
    }
    
    func disconnect(){
        player.detach()
    }
}




