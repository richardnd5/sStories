import Foundation
import UIKit

class Haptics {
    
    var generator = UIImpactFeedbackGenerator()
    
    init() {
        generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
    }
    
    func vibrate(){
        generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        generator.prepare()
    }
}

