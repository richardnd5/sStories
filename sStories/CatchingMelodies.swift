//
//  GameViewController.swift
//  Stroud Stories
//
//  Created by Nathan Richard on 11/21/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit
import SpriteKit

class CatchingMelodies: UIView {
    
    let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createFirstScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func createFirstScene(){
        addSubview(skView)

        skView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        skView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        skView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        skView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

        let scene = GameScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.heigth))
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
//        skView.ignoresSiblingOrder = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}
