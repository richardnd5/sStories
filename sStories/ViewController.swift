/*
 AppDelegate - check
 ViewController - check
 PageView - check
 StoryLine - check
 CatchMelodies - check
 ArrangeMelody
 Sound - check
 Haptics - check
 */

import UIKit

protocol SceneDelegate : class {
    func returnToStory()
}

var collectedMelodies = [Melody]() // This is global.

class ViewController: UIViewController, SceneDelegate {

    enum AppScene {
        case story
        case fishing
        case arranging
    }
    var currentState = AppScene.story
    
    var switchToCatchingMelodiesScene = 5
    var switchToArrangingScene = 0
    
//    var switchToArrangingScene = 9
//    var switchToCatchingMelodiesScene = 0
    
    var page : PageView?
    var catchingMelody : CatchingMelodies?
    var arrangingScene : ArrangingScene?
    
    var currentPage = 0
    var tempStoryLine = 0
    
//    var ourMelody : MelodyAudio?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillSackWithMelodies()
        addPage()
    }
    

    func fillSackWithMelodies(){
        for i in 0...5 {
            
            var whichMelodyType = MelodyType.begin
            
            switch i {
            case 0:
                whichMelodyType = MelodyType.begin
            case 1:
                whichMelodyType = MelodyType.middle
            case 2:
                whichMelodyType = MelodyType.tonic
            case 3:
                whichMelodyType = MelodyType.dominant
            case 4:
                whichMelodyType = MelodyType.ending
            case 5:
                whichMelodyType = MelodyType.final
            default:
                whichMelodyType = MelodyType.begin
            }
            
            let mel = Melody(type: whichMelodyType)
            mel.slotPosition = i
            collectedMelodies.append(mel)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("main view touched")
        if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
            page?.nextStoryLine()
            tempStoryLine+=1
//            Sound.sharedInstance.playTouchUpSound()
            
        } else if page != nil && currentPage < pages.count-1 && (page?.canActivate)! && currentState == .story {
//            Sound.sharedInstance.playTurnUpSound()
            
            page?.fadeOutAndRemove(completion: {
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
            })
        }
    }
    
    func returnToStory(){
        print("it's been tapped. Going back to story.")
//        Sound.sharedInstance.playTurnUpSound()
        
        catchingMelody!.fadeOutAndRemove(completion: {
            self.currentState = .story
            self.currentPage+=1
            self.tempStoryLine = 0
            self.addPage()
        })
    }
    
    func addPage(){
        
        if currentPage == switchToCatchingMelodiesScene {
            catchingMelody = CatchingMelodies(frame: view.frame)
            view.addSubview(catchingMelody!)
            
            catchingMelody?.delegate = self
            
            currentState = .fishing
        } else if currentPage == switchToArrangingScene {
            arrangingScene = ArrangingScene(frame: view.frame)
            view.addSubview(arrangingScene!)
            let safe = view.safeAreaLayoutGuide
            arrangingScene?.anchor(top: safe.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: safe.bottomAnchor)
            currentState = .arranging
        } else {
            page = PageView(frame: view.frame, page: pages[currentPage])
            view.addSubview(page!)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
