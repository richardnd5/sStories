let tempo = 80.0
let switchToCatchingMelodiesScene = 5
let switchToArrangingScene = 9
let switchToPerformingScene = 11

let blurbs = [
    Blurb(textBlurb: "This is the first text blurb. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text. So much text.", imageName: "Templeton"),
    Blurb(textBlurb: "next text. What of it. I am typing so much text. What could it be? Will it wrap? I hope it will wrap.", imageName: "Templeton"),
    Blurb(textBlurb: "more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more .", imageName: "Templeton"),
    Blurb(textBlurb: "more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more .", imageName: "Templeton"),
    Blurb(textBlurb: "more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more .", imageName: "Templeton"),
    Blurb(textBlurb: "more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more .", imageName: "Templeton"),
    Blurb(textBlurb: "more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more .", imageName: "Templeton"),
    Blurb(textBlurb: "more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more more .", imageName: "Templeton"),
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
    Page(imageName: "Town", storyText: storyline[12...12]),
    Page(imageName: "Town", storyText: storyline[12...12]), // this is a dummy slot to make space for the arrangement scene
    Page(imageName: "Performance", storyText: storyline[13...14]),
    Page(imageName: "Performance", storyText: storyline[15...15]), // this is another dummy slot
    Page(imageName: "Performance", storyText: storyline[15...19]),
    Page(imageName: "Pond", storyText: storyline[20...22]),
]

enum SoundEffects : String, CaseIterable {
    // name of sound and file name
    case touchDown = "touchDown"
    case nextStoryLine = "nextStoryLine"
    case touchUp = "touchUp"
    case showPageTurner = "showPageTurner"
    case pageTurn = "pageTurn" //
    case buttonDown = "buttonDown"
    case buttonUp = "buttonUp"
    
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
    case fishingSackFull = "test22"
    case fishingWarning = "fishingWarning"
    
    case arrangingDrag = "arrangingDragSound" //
    case arrangingPlaceMelody = "placeMelodyPause"
    case arrangingCrossOut = "arrangingCrossOutPause"
    case arrangingAllMelodiesLocked = "arrangingAllMelodiesLocked"
}

