/*
 AppDelegate - check
 ViewController - check
 PageView - check
 StoryLine - check
 CatchMelodies
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
    var switchToGameScene = 0
    var page : PageView?
    var catchingMelody : CatchingMelodies?
    let pages = [
        Page(imageName: "Town", storyText: [storyline[0]]),
        Page(imageName: "TalkingToCrowdAboutFishing", storyText: Array(storyline[1...3])),
        Page(imageName: "Mountain", storyText: Array(storyline[4...4])),
        Page(imageName: "Pond", storyText: Array(storyline[5...6])),
        Page(imageName: "Fishing", storyText: Array(storyline[7...8])),
        Page(imageName: "SackOfMelodies", storyText: Array(storyline[9...9])),
        Page(imageName: "ShowingCrowdSackOfMelodies", storyText: Array(storyline[10...11])),
        Page(imageName: "Town", storyText: Array(storyline[12...13])),
        Page(imageName: "Performance", storyText: Array(storyline[14...19])),
        Page(imageName: "Pond", storyText: Array(storyline[20...22])),
        ]
    var currentPage = 0
    var tempStoryLine = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addPage()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        SoundClass.Sound.playTouchDownSound()
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if currentPage == switchToGameScene {
        //            print("We're in page \(switchToGameScene)")
        //
        //        } else
        
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone || UIDevice.current.userInterfaceIdiom == .pad {
            return .landscape
        } else {
            return .landscape
        }
    }
}
