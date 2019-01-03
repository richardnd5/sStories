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

class ViewController: UIViewController {
    
    enum AppScene {
        case story
        case fishing
        case arranging
    }
    var currentState = AppScene.story
    var switchToGameScene = 1
    var page : PageView?
    var catchingMelody : CatchingMelodies?

    var currentPage = 0
    var tempStoryLine = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPage()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! && currentState == .story {
            page?.nextStoryLine()
            tempStoryLine+=1
            SoundClass.Sound.playTouchUpSound()
            
        } else if page != nil && currentPage < pages.count-1 && (page?.canActivate)! && currentState == .story {
            SoundClass.Sound.playTurnUpSound()
            
            page?.fadeOutAndRemove(completion: {
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()
            })
        }
    }
    
    func addPage(){
        
        if currentPage == switchToGameScene {
            catchingMelody = CatchingMelodies(frame: view.frame)
            view.addSubview(catchingMelody!)
            currentState = .fishing
        } else {
            page = PageView(frame: view.frame, page: pages[currentPage])
            view.addSubview(page!)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }    
}
