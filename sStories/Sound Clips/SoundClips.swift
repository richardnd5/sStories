class SoundClips {
        
    static var sharedInstance = SoundClips()
    private var clips = [Sounds : AudioFile]()
    
    init() {
        // fill all the sounds into the sound dictionary
        Sounds.allCases.forEach { (sound) in
            clips[sound] = AudioFile(fileName: sound.rawValue)
        }
    }
    
    func playSound(_ name: Sounds){
        clips[name]!.play()
    }
}



