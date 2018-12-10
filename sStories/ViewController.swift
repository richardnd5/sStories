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
        Page(imageName: "BlankScene", storyText: Array(storyline[0..<2])),
        Page(imageName: "Scene1", storyText: Array(storyline[2..<4])),
        Page(imageName: "Scene2", storyText: Array(storyline[4..<6])),
        Page(imageName: "Scene3", storyText: Array(storyline[6..<8])),
        Page(imageName: "Scene4", storyText: Array(storyline[8..<10])),
        Page(imageName: "BlankScene", storyText: Array(storyline[10..<12])),
        ]
    var currentPage = 0
    var tempStoryLine = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addPage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if tempStoryLine < pages[currentPage].storyText.count-1 && (page?.canActivate)! {
        page?.nextStoryLine()
        tempStoryLine+=1
            
        } else if currentPage < pages.count-1 && (page?.canActivate)! {
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
