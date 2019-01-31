let tempo = 80.0
let switchToCatchingMelodiesScene = 5
let switchToArrangingScene = 9
let switchToPerformingScene = 11

let blurbs = [
    Blurb(textBlurb: "This is the first text blurb", imageName: "Templeton"),
    Blurb(textBlurb: "next text", imageName: "Templeton"),
]

let pages = [
    Page(imageName: "Town", storyText: storyline[0...0]),
    Page(imageName: "TalkingToCrowdAboutFishing", storyText: storyline[1...3]),
    Page(imageName: "Mountain", storyText: storyline[4...4]),
    Page(imageName: "Pond", storyText: storyline[5...6]),
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

enum Sounds : String, CaseIterable {
    // name of sound and file name
    case touchDown = "test4"
    case nextStoryLine = "test26"
    case touchUp = "test5"
    case showPageTurner = "test27"
    case pageTurn = "test6"
    case aboutButtonDown = "test7"
    case aboutButtonUp = "test8"
    case readButtonDown = "test9"
    case readButtonUp = "test10"
    case backButtonDown = "test11"
    case backButtonUp = "test12"
    
    case initialPondDrone = "test13"
    case fishingMelodyOnTheLine = "test14"
    case fishingPullMelodyOut = "test15"
    case fishingTransitionToMelodyChoice = "test16"
    case fishingMelodyDrag = "test28"
    case fishingMelodyThrowBack = "test29"
    case fishingMelodyPutBackToSack = "test30"
    case fishingSackDrag = "test17"
    case fishingSackDrop = "test18"
    case fishingThrowbackDrag = "test19"
    case fishingThrowbackDrop = "test20"
    case fishingCastLine = "test21"
    case fishingSackFull = "test22"
    case fishingWarning = "test31"
    
    case arrangingDrag = "test23"
    case arrangingPlaceMelody = "test24"
    case arrangingAllMelodiesLocked = "test25"
}


