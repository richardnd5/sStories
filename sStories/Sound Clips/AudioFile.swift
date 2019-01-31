import AudioKit

class AudioFile {
    
    private var audioFile : AKAudioFile!
    private var player : AKPlayer!
    var name : String!
    
    
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
        player.connect(to: Sound.sharedInstance.mixer)
        player.completionHandler = finishedCallback
    }
    
    private func finishedCallback(){
        print("\(name) finishedPlaying")
    }
    
    func play(){
        if player.isPlaying {
            player.stop()
        }
        player.play()
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
    
    func disconnect(){
        player.detach()
    }
}



