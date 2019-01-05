struct Page {
    let imageName: String
    let storyText: [String]
}

let pages = [
    Page(imageName: "Town", storyText: [storyline[0]]),
    Page(imageName: "TalkingToCrowdAboutFishing", storyText: Array(storyline[1...3])),
    Page(imageName: "Mountain", storyText: Array(storyline[4...4])),
    Page(imageName: "Pond", storyText: Array(storyline[5...6])),
    Page(imageName: "Fishing", storyText: Array(storyline[7...7])),
    Page(imageName: "SackOfMelodies", storyText: Array(storyline[9...9])),
    Page(imageName: "ShowingCrowdSackOfMelodies", storyText: Array(storyline[10...11])),
    Page(imageName: "Town", storyText: Array(storyline[12...13])),
    Page(imageName: "Performance", storyText: Array(storyline[14...19])),
    Page(imageName: "Pond", storyText: Array(storyline[20...22])),
]

var collectedMelodies = [Int]()
