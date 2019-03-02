// Use a delegate and put this in the view controller.
var collectedMelodies = [Melody]()

var totalBubbleScore = 0 {
    didSet {
        if totalBubbleScore >= 30 {
            totalBubbleScore = 30
        }
    }
}
