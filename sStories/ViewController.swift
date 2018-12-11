/*
 
 AppDelegate - check
 ViewController - check
 PageView - check
 StoryLine - check
 CatchMelodies
 ArrangeMelody
 Sound
 Haptics
 
 
 */

import UIKit

class ViewController: UIViewController {
    
    var page : PageView?
    let pages = [
        Page(imageName: "BlankScene", storyText: Array(storyline[0...1])),
        Page(imageName: "BlankScene", storyText: Array(storyline[1...3])),
        Page(imageName: "BlankScene", storyText: Array(storyline[4...6])),
        Page(imageName: "BlankScene", storyText: Array(storyline[7...9])),
        Page(imageName: "BlankScene", storyText: Array(storyline[10...15])),
        Page(imageName: "BlankScene", storyText: Array(storyline[16...17])),
        
        ]
    var currentPage = 0
    var tempStoryLine = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addPage()
        SoundClass.Sound.setupSound()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SoundClass.Sound.playTouchDownSound()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! {
        page?.nextStoryLine()
        tempStoryLine+=1
            SoundClass.Sound.playTouchUpSound()

        } else if currentPage < pages.count-1 && (page?.canActivate)! {
            SoundClass.Sound.playTurnUpSound()

            page?.fadeOutAndRemove(completion: {
                self.currentPage+=1
                self.tempStoryLine = 0
                self.addPage()

            })
        }
    }
    
    func addPage(){
            page = PageView(frame: view.frame, page: pages[currentPage])
            view.addSubview(page!)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
