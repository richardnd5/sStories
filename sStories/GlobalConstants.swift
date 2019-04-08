let tempo = 80.0
let switchToCatchingMelodiesScene = 5
let switchToArrangingScene = 9
let switchToPerformingScene = 11

let blurbs = [
    Blurb(textBlurb: """
        About the creator:
        
        Nathan is a professional musician who found an interest in software development after taking an electronic music course during his graduate work in music composition. Some of his lifelong goals are to make music accessible to as many people as he can and create opportunities for people to be creative.

        """, imageName: "performingImage7"),
    
    Blurb(textBlurb: "Templeton’s Fishing Journey was written and built for my nephew, Stroud.", imageName: "Templeton"),
    
    Blurb(textBlurb: "It is my hope that this app will help spark in him an interest in music.", imageName: "performingImage0"),
    
    Blurb(textBlurb: "Thank you to my father, David, who hand-carved Templeton from a piece of wood.", imageName: "performingImage1"),
    
    Blurb(textBlurb: "Thank you to my father and mother, Cassandra, for taking the photographs and drawing the images for the scenes.", imageName: "performingImage1.5"),
    Blurb(textBlurb: "Thank you to my dear friends, Peter and Tara, for helping edit the story.", imageName: "performingImage2"),
    
    Blurb(textBlurb: "Thank you to my friends, Ivan, Jayson, Peter, Tara, and Anthony for providing feedback throughout the creation of the app.", imageName: "performingImage3"),
    
    Blurb(textBlurb: "Thank you to Aurelius Prochazka and the community of AudioKit for creating and maintaining the framework used for the audio of this app.", imageName: "performingImage4"),
    
    Blurb(textBlurb: "And lastly, thank you to my sister, brother-in-law, and nephew for providing the inspiration and drive for this creation.", imageName: "performingImage5"),
    
    Blurb(textBlurb: "With utmost sincerity and love, Nathan", imageName: "performingImage6"),
    
    
    
    Blurb(textBlurb: """
            With the exception of the sparrow, chickadee, and robin sounds downloaded from freesounds.com, the sound effects were recorded in my closet. I filled a waste basket with water and splashed around for the lake. I taped a metal wire to a rollerblade wheel for the fishing pole and a pencil in a music manuscript book when you drag the melodies to arrange them. The rest with sounds from my mouth. All sounds were edited in Logic Pro.
        """, imageName: "performingImage8"),
    
    Blurb(textBlurb: """
            The piano melodies were improvised. The images were altered through the iOS app, "Imaengine,” and cleaned up in the AutoDesk iOS app, "Sketchbook."
        """, imageName: "performingImage9"),
    
    Blurb(textBlurb: """
            Having learned so much through this process, I have so many ideas for future projects.
        """, imageName: "performingImage10"),
    
    Blurb(textBlurb: "Feel free to leave a review.", imageName: "whiteDot"),
    
    
    Blurb(textBlurb: "Go be creative!", imageName: "whiteDot")
    
]

let pages = [
    Page(imageName: "Town", storyText: storyline[0...0]),
    Page(imageName: "TalkingToCrowdAboutFishing", storyText: storyline[1...3]),
    Page(imageName: "Mountain", storyText: storyline[4...4]),
    Page(imageName: "PondNew", storyText: storyline[5...6]),
    Page(imageName: "Fishing", storyText: storyline[7...7]),
    Page(imageName: "SackOfMelodies", storyText: storyline[8...8]), // this is a dummy slot to make space for the catching melodies scene
    Page(imageName: "SackOfMelodies", storyText: storyline[8...9]),
    Page(imageName: "ShowingCrowdSackOfMelodies", storyText: storyline[10...11]),
    Page(imageName: "Cabin", storyText: storyline[12...12]),
    Page(imageName: "Cabin", storyText: storyline[12...12]), // this is a dummy slot to make space for the arrangement scene
    Page(imageName: "Performance", storyText: storyline[13...14]),
    Page(imageName: "Performance", storyText: storyline[15...15]), // this is another dummy slot
    Page(imageName: "Performance", storyText: storyline[15...19]),
    Page(imageName: "PondNew", storyText: storyline[20...20]),
    Page(imageName: "stars", storyText: storyline[21...22]),
]

//let arpeggioArray : Array<Array<PageTurnPianoNote>> = [
//    [.Gb2,.Db3],
//    [.Ab2,.Eb3],
//    [.Bb2,.F3],
//    [.Db3,.Ab3],
//    [.F2,.Db3],
//
//    [.Gb2,.Db3],
//    [.Ab2,.Eb3],
//    [.Ab2,.C3],
//    [.Ab2,.Db3],
//    [.F2,.Db3],
//
//    [.Gb2,.Db3],
//    [.Ab2,.Eb3],
//    [.Bb2,.F3],
//    [.C3,.Db3],
//    [.F2,.Db3],
//
//    [.Gb2,.Db3],
//    [.Ab2,.Eb3],
//    [.Ab2,.C3],
//    [.Ab2,.Db3],
//    [.F2,.Db3]
//]

let arpeggioArray : Array<Array<PageTurnPianoNote>> = [
[.Gb2,.Db3,.Gb3,.Ab3,.Bb3,.Db4,.Gb4,.Ab4,.Db5],
[.Ab2,.Eb3,.Ab3,.Bb3,.C4,.Db4,.Eb4,.Ab4,.Eb5],
[.Bb2,.F3,.Ab3,.Bb3,.C4,.Db4,.F4,.Ab4,.Db5],
[.C3,.Db3,.Ab3,.Bb3,.Db4,.Eb4,.Ab4,.C5,.Eb5],
[.F2,.Db3,.Ab3,.C4,.Db4,.Eb4,.Gb4,.Ab4,.Db5,.Eb5],

[.Gb2,.Db3,.Ab3,.Bb3,.C4,.Db4,.Eb4,.Ab4,.Eb5],
[.Ab2,.Eb3,.Bb3,.C4,.Db4,.Eb4,.F4,.Ab4,.Bb4],
[.Ab2,.C3,.F3,.Gb3,.Ab3,.Eb4,.Ab4,.Gb4,.C5],
[.Ab2,.Db3,.Ab3,.C4,.Db4,.Eb4,.Ab4,.C5,.Eb5],
[.F2,.Db3,.Ab3,.Db4,.Eb4,.F4,.Ab4,.Db5],

[.Gb2,.Db3,.Gb3,.Ab3,.Bb3,.Db4,.Gb4,.Ab4,.Db5],
[.Ab2,.Eb3,.Ab3,.Bb3,.C4,.Db4,.Eb4,.Ab4,.Eb5],
[.Bb2,.F3,.Ab3,.Bb3,.C4,.Db4,.F4,.Ab4,.Db5],
[.C3,.Db3,.Ab3,.Bb3,.Db4,.Eb4,.Ab4,.C5,.Eb5],
[.F2,.Db3,.Ab3,.C4,.Db4,.Eb4,.Gb4,.Ab4,.Db5,.Eb5],

[.Gb2,.Db3,.Ab3,.Bb3,.C4,.Db4,.Eb4,.Ab4,.Eb5],
[.Ab2,.Eb3,.Bb3,.C4,.Db4,.Eb4,.F4,.Ab4,.Bb4],
[.Ab2,.C3,.F3,.Gb3,.Ab3,.Eb4,.Ab4,.Gb4,.C5],
[.Ab2,.Db3,.Ab3,.C4,.Db4,.Eb4,.Ab4,.C5,.Eb5],
[.F2,.Db3,.Ab3,.Db4,.Eb4,.F4,.Ab4,.Db5]
]

enum SoundEffects : String, CaseIterable {
    // name of sound and file name
    case openingMusic = "openingMusic"
    case touchDown = "touchDown"
    case nextStoryLine = "nextStoryLine"
    case touchUp = "touchUp"
    case showPageTurner = "showPageTurner"
    case pageTurn = "pageTurn" //
    case buttonDown = "buttonDown"
    case buttonUp = "buttonUp"
    case waterPlink = "waterPlink"
    
    case initialPondDrone = "test13"
    case fishingMelodyOnTheLine = "fishOnLine" //
    case fishingPullMelodyOut = "pullMelodyOut"
    case fishingTransitionToMelodyChoice = "test16"
    case fishingMelodyDrag = "test28"
    case fishingSackDrag = "sackDrag" //
    case fishingSackDrop = "sackDrop" //
    case fishingThrowbackDrag = "throwbackDrag"
    case fishingThrowbackDrop = "throwBackDrop"
    case fishingCastLine = "castLine"
    case fishingSackFull = "fishingSackFull"
    case fishingWarning = "fishingWarning"
    
    case arrangingMelodiesAppear = "arrangingMelodiesAppear"
    case arrangingDrag = "arrangingDragSound" //
    case arrangingPlaceMelody = "placeMelodyPause"
    case arrangingCrossOut = "arrangingCrossOutPause"
    case arrangingAllMelodiesLocked = "arrangingAllMelodiesLocked"
    
    case arrangingPlaceSound1 = "arrangingPlaceSound1"
    case arrangingPlaceSound2 = "arrangingPlaceSound2"
    case arrangingPlaceSound3 = "arrangingPlaceSound3"
    case arrangingPlaceSound4 = "arrangingPlaceSound4"
    case arrangingPlaceSound5 = "arrangingPlaceSound5"
    case arrangingPlaceSound6 = "arrangingPlaceSound6"
    
    case openingNoodle = "openingNoodle"
    
    case byeahSound1 = "byeahSound1"
    case byeahSound2 = "byeahSound2"
    case byeahSound3 = "byeahSound3"
    case byeahSound4 = "byeahSound4"
    case byeahSound5 = "byeahSound5"
    case byeahSound6 = "byeahSound6"
    case byeahSound7 = "byeahSound7"
    case byeahSound8 = "byeahSound8"
    case byeahSound9 = "byeahSound9"
    case byeahSound10 = "byeahSound10"
    case byeahSound11 = "byeahSound11"
    case byeahSound12 = "byeahSound12"
}

