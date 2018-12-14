import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        physicsBody?.isDynamic = false
        
        physicsBody?.allowsRotation = true
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        physicsBody?.friction = 0
        physicsBody?.restitution = 1
        physicsBody?.categoryBitMask = UInt32()
        physicsBody?.collisionBitMask = UInt32()
        physicsBody?.contactTestBitMask = UInt32()
        isUserInteractionEnabled = true
        
//        let templeton = Templeton(width: 100, height: 100)
//        addChild(templeton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let location = t.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        SoundClass.Sound.playPattern()
        print("howdy")
    }
}
