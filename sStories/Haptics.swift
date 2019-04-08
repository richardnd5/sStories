import Foundation
import UIKit

class Haptics {
    
    static var shared = Haptics()
    var generator = UIImpactFeedbackGenerator()
    
    init() {
        generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
    }
    
    func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium){
        generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
        generator.prepare()
    }
}

