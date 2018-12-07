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
        textView.font = UIFont(name: "Papyrus", size: 28)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Papyrus", size: 28)
        return textView
    }()
    
    var imageName = String()
    var storyText = [String]()
    var sceneStoryPosition = 0
    
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
        
        setupLayout()
        backgroundColor = .black
        
    }
    
    func nextStoryLine(){
        
        //            storyTextView.fadeTransition(1.0)
        storyTextView.pushTransition(1.0)
        sceneStoryPosition += 1
        storyTextView.text = storyText[sceneStoryPosition]
    }
    
    func setupLayout(){
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        addSubview(storyTextView)
        
        storyTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storyTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
