//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class PageView: UIView {
    
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let storyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Papyrus", size: 28)
        return textView
    }()
    
    var imageName = String()
    var storyText = [String]()
    var sceneStoryPosition = 0
    var canActivate = false
    
    init(frame: CGRect, page: Page) {
        super.init(frame: frame)
        imageName = page.imageName
        storyText = page.storyText
        
        //  get URL of image
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("\(page.imageName).png")
        
        // Downsample it to fit the set dimensions
        let ourImage = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        
        imageView.image = ourImage
        storyTextView.text = page.storyText[sceneStoryPosition]
        storyTextView.font = UIFont(name: "Papyrus", size: frame.width/44)
        
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
    
    func nextStoryLine(){
        
        if canActivate{
            fadeTo(view: storyTextView, time: 1.0, opacity: 0.0, {
                if self.canActivate {
                    self.sceneStoryPosition += 1
                    self.storyTextView.text = self.storyText[self.sceneStoryPosition]
                    self.fadeTo(view: self.storyTextView, time: 1.0, opacity: 1.0, {})
                }
            })
        }
    }
    
    func setupLayout(){
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/2.5).isActive = true
        
        addSubview(storyTextView)
        storyTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        storyTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30).isActive = true
        storyTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storyTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/5).isActive = true
        storyTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/5).isActive = true
        
        
    }
    
    func fadeOutAndRemove(completion: @escaping ( ) -> ( ) ){
        if canActivate{
            fadeTo(view: self, time: 1.0, opacity: 0.0, {
                self.removeFromSuperview()
                completion()
                self.canActivate = true
            })
        }
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
