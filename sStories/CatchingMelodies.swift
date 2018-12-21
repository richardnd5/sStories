//
//  GameViewController.swift
//  Stroud Stories
//
//  Created by Nathan Richard on 11/21/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class CatchingMelodies: UIView {
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var fishingPole = UIImageView()
    var poleImage = UIImage()
    var canActivate = false
    var shouldRotate = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  get URL of image
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("Pond.png")
        // Downsample it to fit the set dimensions
        let ourImage = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        
        let fishingPoleURL = Bundle.main.resourceURL?.appendingPathComponent("FishingPole.png")
        poleImage = downsample(imageAt: fishingPoleURL!, to: CGSize(width: frame.height, height: frame.height), scale: 1)
        imageView.image = ourImage
        
        fishingPole = UIImageView(frame: CGRect(x: frame.width/2-frame.width/8, y: frame.height+40, width: frame.width/4, height: frame.height/2))
        fishingPole.contentMode = .bottom
        fishingPole.isUserInteractionEnabled = false
        
        fishingPole.image = poleImage
        fishingPole.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)

        setupLayout()
        backgroundColor = .black
        alpha = 0
        fadeTo(view:self, time: 1.5,opacity: 1.0, {})
        
    }
    
    
    func fadeTo(view: UIView, time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        canActivate = false
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = opacity
        },
            completion: {
                _ in
                self.canActivate = true
                completion()
        })
    }
    
    func setupLayout(){
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(fishingPole)
        rotateImage(fishingPole)
        
    }
    
    
    private func rotateImage(_ view: UIImageView) {
        
        shouldRotate.toggle()
        
        let angle: CGFloat = shouldRotate ? .pi / 70 : .pi / -70

        UIView.animate(
            withDuration: 4.0,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.transform = CGAffineTransform(rotationAngle: angle)
        },
            completion: {
                _ in
                self.rotateImage(view)
        })
    }
    
    var readyToCastSlashReelIn = true
    private func catchFish(_ view: UIImageView) {
        
        
            readyToCastSlashReelIn = false
        
            UIView.animate(
                withDuration: 2.0,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    print("Pulling pole out")
                    view.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
                    view.alpha = 0.0
            },
                completion: {
                    _ in
                    self.fishingPoleIn = false
                    self.readyToCastSlashReelIn = true

            })
        
    }
    
    private func putFishingPoleBackIn(_ view: UIImageView){

        
        readyToCastSlashReelIn = false
        UIView.animate(
            withDuration: 2.0,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                print("putting pole in")
                view.alpha = 1.0
                
        },
            completion: {
                _ in
                self.fishingPoleIn = true
                self.readyToCastSlashReelIn = true

                
        })
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fishingPoleIn = true
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if readyToCastSlashReelIn {
        if fishingPoleIn {
            catchFish(fishingPole)

        } else if !fishingPoleIn {
            putFishingPoleBackIn(fishingPole)

        }
        }

    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: frame.width/2, y: frame.height/2)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: 20, height: 20)
        
        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)
        
        particleEmitter.emitterCells = [red, green, blue]
        
        layer.addSublayer(particleEmitter)
    }
    
    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
//        let cell = CAEmitterCell()
//        cell.birthRate = 100
//        cell.duration = 0.2
//
//        cell.lifetime = 7.0
//        cell.lifetimeRange = 0
//        cell.color = color.cgColor
//        cell.velocity = 200
//        cell.velocityRange = 50
//        cell.emissionLongitude = CGFloat.pi
//        cell.emissionRange = CGFloat.pi / 4
//        cell.spin = 2
//        cell.spinRange = 3
//        cell.scaleRange = 0.5
//        cell.scaleSpeed = -0.05
//
//        cell.contents = UIImage(named: "waterDrop")?.cgImage
        let emitterCell = CAEmitterCell()
//        emitterCell.emissionLongitude = CGFloat(M_PI / 2)
//        emitterCell.emissionLatitude = 0
//        emitterCell.lifetime = 0.6
//        emitterCell.alphaSpeed = -0.7;
//        emitterCell.birthRate = 6
//        emitterCell.velocity = 300
//        emitterCell.velocityRange = 100
//        emitterCell.yAcceleration = 150
//        emitterCell.emissionRange = CGFloat(M_PI / 4)
//        let newColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
//        emitterCell.color = newColor;
//
//        emitterCell.redRange = 0.0;
//        emitterCell.greenRange = 0.0;
//        emitterCell.blueRange = 0.2;
//        emitterCell.name = "base"
        
        
        
        emitterCell.birthRate = 19999;
        emitterCell.scale = 0.6;
        emitterCell.velocity = 130;
        emitterCell.lifetime = 100;
        emitterCell.alphaSpeed = -0.2;
        emitterCell.yAcceleration = -80;
        emitterCell.beginTime = 1.5;
        emitterCell.duration = 0.1;
        emitterCell.emissionRange = 2 * CGFloat(M_PI);
        emitterCell.scaleSpeed = -0.1;
        emitterCell.spin = 2;
        
        
        
        emitterCell.contents = UIImage(named: "waterDrop")?.cgImage
        return emitterCell
    }
    
    func createFireWorks(){

        let img = UIImage(named: "waterDrop")?.cgImage
        
        let emitterCell = CAEmitterCell()
        emitterCell.emissionLongitude = CGFloat(M_PI / 2)
        emitterCell.emissionLatitude = 0
        emitterCell.lifetime = 2.6
        emitterCell.birthRate = 6
        emitterCell.velocity = 300
        emitterCell.velocityRange = 100
        emitterCell.yAcceleration = 150
        emitterCell.emissionRange = CGFloat(M_PI / 4)
        let newColor = UIColor(displayP3Red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        emitterCell.color = newColor;
        
        emitterCell.redRange = 0.9;
        emitterCell.greenRange = 0.9;
        emitterCell.blueRange = 0.9;
        emitterCell.name = "base"
        
        let flareCell =  CAEmitterCell()
        flareCell.contents = img;
        flareCell.emissionLongitude = CGFloat(4 * M_PI) / 2;
        flareCell.scale = 0.4;
        flareCell.velocity = 80;
        flareCell.birthRate = 45;
        flareCell.lifetime = 0.5;
        flareCell.yAcceleration = -350;
        flareCell.emissionRange = CGFloat(M_PI / 7);
        flareCell.alphaSpeed = -0.7;
        flareCell.scaleSpeed = -0.1;
        flareCell.scaleRange = 0.1;
        flareCell.beginTime = 0.01;
        flareCell.duration = 1.7;
        
        let fireworkCell = CAEmitterCell()
        
        fireworkCell.contents = img;
        fireworkCell.birthRate = 19999;
        fireworkCell.scale = 0.6;
        fireworkCell.velocity = 130;
        fireworkCell.lifetime = 100;
        fireworkCell.alphaSpeed = -0.2;
        fireworkCell.yAcceleration = -80;
        fireworkCell.beginTime = 1.5;
        fireworkCell.duration = 0.1;
        fireworkCell.emissionRange = 2 * CGFloat(M_PI);
        fireworkCell.scaleSpeed = -0.1;
        fireworkCell.spin = 2;
        
        emitterCell.emitterCells = [flareCell,fireworkCell]

        
    }

}
