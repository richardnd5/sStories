class SoundClips {
        
    static var sharedInstance = SoundClips()
    private var clips = [SoundEffects : SoundEffect]()
    
    init() {
        // fill all the sounds into the sound dictionary
        SoundEffects.allCases.forEach { (sound) in
            if sound == SoundEffects.nextStoryLine ||
               sound == SoundEffects.touchDown ||
               sound == SoundEffects.fishingSackDrag ||
               sound == SoundEffects.fishingSackDrop
            {
                clips[sound] = SoundEffect(fileName: sound.rawValue, volume: 0.8)
            } else {
                clips[sound] = SoundEffect(fileName: sound.rawValue)
            }
            
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
    
    func loopSoundEffect(_ name: SoundEffects){
        clips[name]!.loop()
    }
    
    func stopLoopedSoundEffect(_ name: SoundEffects){
        clips[name]!.stopLoop()
    }
}
