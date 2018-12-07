/*
 
 AppDelegate - check
 ViewController - check
 StoryView
 CatchMelodies
 ArrangeMelody
 Sound
 Haptics
 
 
 */

import UIKit

class ViewController: UIViewController {
    
    
    var page : PageView?
    let pages = [
        Page(imageName: "BlankScene", storyText: [      "line1",
                                                        "line2",
                                                        "line3",
                                                        "line3.1",
                                                        "line3.2",
                                                        "line3.3",
                                                        "line3.4",
                                                        "line3.5",
                                                        "line3.6",]),
        Page(imageName: "Scene1", storyText: [          "line4",
                                                        "line5"]),
        Page(imageName: "Pond", storyText: [            "line6",
                                                        "line7"]),
        Page(imageName: "Scene2", storyText: [          "line8",
                                                        "line9"]),
        Page(imageName: "Scene3", storyText: [          "line10",
                                                        "line11"]),
        Page(imageName: "Scene4", storyText: [          "line12",
                                                        "line13"]),
        ]
    var currentPage = 0
    var tempStoryLine = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        addPage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if tempStoryLine < pages[currentPage].storyText.count-1{
        page?.nextStoryLine()
        tempStoryLine+=1
            
        } else if currentPage < pages.count-1 {
            page?.removeFromSuperview()
            currentPage+=1
            tempStoryLine = 0
            addPage()
            
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
