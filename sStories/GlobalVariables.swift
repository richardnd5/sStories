// Use a delegate and put this in the view controller.
var collectedMelodies = [Melody]()

var bubbleLimit = 5

var totalBubbleScore = 0 {
    didSet {
        if totalBubbleScore >= bubbleLimit {
            totalBubbleScore = bubbleLimit
        }
    }
}
