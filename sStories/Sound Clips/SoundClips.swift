class SoundClips {
        
    static var sharedInstance = SoundClips()
    private var clips = [SoundEffects : AudioFile]()
    
    init() {
        // fill all the sounds into the sound dictionary
        SoundEffects.allCases.forEach { (sound) in
            clips[sound] = AudioFile(fileName: sound.rawValue)
        }
    }
    
    func playSound(_ name: SoundEffects){
        clips[name]!.play()
    }
    
    func playAtRandomIntervals(_ name: SoundEffects){
        clips[name]!.playRandomIntervalAndPitch()
    }
    
    func stopSound(_ name: SoundEffects){
        clips[name]!.stopReplaying()
    }
}
