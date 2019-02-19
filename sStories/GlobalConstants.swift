let tempo = 80.0
let switchToCatchingMelodiesScene = 5
let switchToArrangingScene = 9
let switchToPerformingScene = 11

let blurbs = [
    Blurb(textBlurb: "Templeton’s Fishing Journey was written and built for my nephew, Stroud.", imageName: "Templeton"),
    Blurb(textBlurb: "It is my hope that this app will help spark in him an interest in music.", imageName: "performingImage0"),
    Blurb(textBlurb: "Thank you to my father, David, who hand carved Templeton from a piece of wood.", imageName: "performingImage1"),
    Blurb(textBlurb: "Thank you to my mother, Cassandra and my father for taking the photographs and drawing the  images for the scenes.", imageName: "performingImage1.5"),
    Blurb(textBlurb: "Thank you to my dear friends, Peter and Tara for helping edit the story.", imageName: "performingImage2"),
    Blurb(textBlurb: "Thank you to my friends, Ivan, Jayson, Peter, Tara, and Anthony for providing feedback throughout the creation of the app.", imageName: "performingImage3"),
    Blurb(textBlurb: "Thank you to Aurelius Prochazka and the community of AudioKit for creating and maintaining the framework used for the audio portion of the app.", imageName: "performingImage4"),
    Blurb(textBlurb: "And lastly, thank you to my sister, brother in law and nephew, Stroud for providing the inspiration and drive for the creation.", imageName: "performingImage5"),
    Blurb(textBlurb: "With Utmost Sincerity and Love, Nathan", imageName: "performingImage6"),
    Blurb(textBlurb: """
        About the creator.
        
        I am a professional musician who found an interest in software development after taking an electronic music course during my graduate work in music composition. I'm a self-taught developer who is obsessed with learning. Some of my lifelong goals are to make music accessible to as many people as I can, and create opportunities for people to be creative.
        """, imageName: "performingImage7"),
    Blurb(textBlurb: """
            With the exception of the sparrow, chickadee, and robin sounds downloaded from freesounds.com, the sound effects were recorded in my closet. I filled a waste basket with water and splashed around, taped a metal wire to a rollerblade wheel for the fishing pole, a pencil in a music manuscript book, and the rest with sounds from my mouth. All edited in Logic Pro.
        """, imageName: "performingImage8"),
    Blurb(textBlurb: """
            The piano melodies were improvised. The images were altered through the iOS app, "Imaengine" and cleaned up in the AutoDesk iOS app, "Sketchbook"
        """, imageName: "performingImage9"),
    Blurb(textBlurb: """
            I learned so much through this process (especially what not to do in software development for my later projects...)
        """, imageName: "performingImage10"),
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
    Page(imageName: "PondNew", storyText: storyline[20...22]),
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
}

