import UIKit

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

let tempo = 80.0
let switchToCatchingMelodiesScene = 5
let switchToArrangingScene = 9
let switchToPerformingScene = 11

let pages = [
    Page(imageName: "Town", storyText: [storyline[0]]),
    Page(imageName: "TalkingToCrowdAboutFishing", storyText: Array(storyline[1...3])),
    Page(imageName: "Mountain", storyText: Array(storyline[4...4])),
    Page(imageName: "Pond", storyText: Array(storyline[5...6])),
    Page(imageName: "Fishing", storyText: Array(storyline[7...7])),
    Page(imageName: "SackOfMelodies", storyText: Array(storyline[8...8])), // this is a dummy slot to make space for the catching melodies scene
    Page(imageName: "SackOfMelodies", storyText: Array(storyline[8...9])),
    Page(imageName: "ShowingCrowdSackOfMelodies", storyText: Array(storyline[10...11])),
    Page(imageName: "Town", storyText: Array(storyline[12...12])),
    Page(imageName: "Town", storyText: Array(storyline[12...12])), // this is a dummy slot to make space for the arrangement scene
    Page(imageName: "Performance", storyText: Array(storyline[13...14])),
    Page(imageName: "Performance", storyText: Array(storyline[15...15])), // this is another dummy slot
    Page(imageName: "Performance", storyText: Array(storyline[15...19])),
    Page(imageName: "Pond", storyText: Array(storyline[20...22])),
]

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
    static let maxWH = max(ScreenSize.width, ScreenSize.height)
}

struct DeviceType {
    static let iPhone4orLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH < 568.0
    static let iPhone5orSE   = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 568.0
    static let iPhone678     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 667.0
    static let iPhone678p    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 736.0
    static let iPhoneX       = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 812.0
    static let iPhoneXRMax   = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 896.0
    static var hasNotch: Bool {
        return iPhoneX || iPhoneXRMax
    }
}


