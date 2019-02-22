class SoundClips {
        
    static var sharedInstance = SoundClips()
    private var clips = [SoundEffects : SoundEffect]()
    
    init() {
        // fill all the sounds into the sound dictionary
        // These sound effects are to be turned down. That's what this is all about.
        SoundEffects.allCases.forEach { (sound) in
            if sound == SoundEffects.nextStoryLine ||
               sound == SoundEffects.touchDown ||
                sound == SoundEffects.touchUp ||
               sound == SoundEffects.fishingSackDrag ||
               sound == SoundEffects.fishingSackDrop ||
               sound == SoundEffects.arrangingDrag ||
               sound == SoundEffects.arrangingPlaceMelody ||
               sound == SoundEffects.arrangingCrossOut ||
               sound == SoundEffects.arrangingMelodiesAppear
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
    
    func playPitched(_ name: SoundEffects){
        clips[name]!.playPitched()
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
