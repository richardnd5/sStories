let tempo = 80.0
let switchToCatchingMelodiesScene = 5
let switchToArrangingScene = 9
let switchToPerformingScene = 11

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
    case test = "test"
    case test2 = "test2"
    case test3 = "test3"
    case piano = "melody6"
}
