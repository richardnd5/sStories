struct Page {
    let imageName: String
    let storyText: [String]
}

enum MelodyType : CaseIterable {
    case begin
    case middle
    case tonic
    case dominant
    case ending
    case final
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

class Melody {
    
    let type : MelodyType
    var number = Int()
    var slotPosition = Int()
    
    init(type: MelodyType){
        self.type = type
        number = setNumber()
    }
    
    private func setNumber() -> Int{
        
        // depending on the type, choose which pattern number.
        switch type {
        case .begin:
            return Int.random(in: 0...9)
        case .middle:
            return Int.random(in: 10...19)
        case .tonic:
            return Int.random(in: 20...29)
        case .dominant:
            return Int.random(in: 30...39)
        case .ending:
            return Int.random(in: 40...49)
        case .final:
            return Int.random(in: 50...54)
        }
    }
}




