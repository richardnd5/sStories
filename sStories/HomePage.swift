//
//  PageCell.swift
//  Stroud Story UIView
//
//  Created by Nate on 12/5/18.
//  Copyright © 2018 Nathan Richard. All rights reserved.
//

import UIKit

class HomePage: UIView {
    
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let aboutButton: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let readButton: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let title: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Papyrus", size: 30)
        return textView
    }()
    
    weak var delegate : SceneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  get URL of image
        let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("Templeton.png")
        // Downsample it to fit the set dimensions
        let ourImage = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        
        imageView.image = ourImage
        
        title.text = "Templeton's Fishing Journey"
        title.font = UIFont(name: "Papyrus", size: frame.width/20)
        
        
        
        let url = Bundle.main.resourceURL?.appendingPathComponent("questionMark.png")
        // Downsample it to fit the set dimensions
        let aboutImage = downsample(imageAt: url!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        aboutButton.image = aboutImage
        
        let readURL = Bundle.main.resourceURL?.appendingPathComponent("playButton.png")
        // Downsample it to fit the set dimensions
        let readImage = downsample(imageAt: readURL!, to: CGSize(width: frame.width, height: frame.height), scale: 1)
        readButton.image = readImage
        
        setupLayout()
        setupGestures()
        backgroundColor = .black
        alpha = 0
        layer.zPosition = 100
        fadeTo(view:self, time: 1.5,opacity: 1.0, {})
        
        
    }
    
    func setupLayout(){
        
        let safe = safeAreaLayoutGuide
        let bottomPadding = -frame.height/40
        
        addSubview(title)
        title.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/14).isActive = true
        title.heightAnchor.constraint(equalToConstant: frame.height/1.4)
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width/10).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width/10).isActive = true
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: frame.height/230).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/4).isActive = true
        
        addSubview(readButton)
        readButton.translatesAutoresizingMaskIntoConstraints = false
        readButton.widthAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        readButton.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        readButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        readButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: bottomPadding).isActive = true
//        readButton.topAnchor.constraint(equalTo: aboutButton.topAnchor).isActive = true
        
        addSubview(aboutButton)
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.topAnchor.constraint(equalTo: readButton.topAnchor).isActive = true
//        aboutButton.heightAnchor.constraint(equalToConstant: frame.height/11).isActive = true
        aboutButton.widthAnchor.constraint(equalToConstant: frame.height/9).isActive = true
        aboutButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: bottomPadding).isActive = true
        aboutButton.bottomAnchor.constraint(equalTo: readButton.bottomAnchor).isActive = true
    }
    
    func setupGestures(){
        let readTap = UITapGestureRecognizer(target: self, action: #selector(handleReadTap))
        readButton.addGestureRecognizer(readTap)
        
        let aboutTap = UITapGestureRecognizer(target: self, action: #selector(handleAboutTap))
        aboutButton.addGestureRecognizer(aboutTap)
    }
    
    @objc func handleReadTap(_ sender: UITapGestureRecognizer){
        delegate?.startStory()
    }
    
    @objc func handleAboutTap(_ sender: UITapGestureRecognizer){
        delegate?.goToAboutPage()
    }
    
    func fadeTo(view: UIView, time: Double,opacity: CGFloat, _ completion: @escaping () ->()){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.alpha = opacity
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func fadeOutAndRemove(completion: @escaping ( ) -> ( ) ){
            fadeTo(view: self, time: 1.0, opacity: 0.0, {
                self.removeFromSuperview()
                completion()
            })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
