// Use a delegate and put this in the view controller.
var collectedMelodies = [Melody]()

var bubbleLimit = 10

var totalBubbleScore = 0 {
    didSet {
        if totalBubbleScore >= bubbleLimit {
            totalBubbleScore = bubbleLimit
        }
    }
}
