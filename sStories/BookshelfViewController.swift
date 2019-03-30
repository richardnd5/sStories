import UIKit

class BookshelfViewController: UIViewController {
    
    var bookshelfPage : BookshelfPage!
    var donatePopUpView : DonatePopUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block:{_ in
            self.createBookShelfPage()
        })
    }
    
    func showTempleton(){
        
        view.fadeTo(opacity: 0.0, time: 0.8, {

//            UINavigationController.attemptRotationToDeviceOrientation()
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            let templetonController = TempletonViewController()
            self.present(templetonController, animated: false, completion: {
                print("she was presented")
            })
        })

    }
    
    
    
    func setupStoryIconDelegates(){
        for view in bookshelfPage.stackViewTop.subviews {
//            let v = view as! StoryIcon
//            v.delegate = self
        }
    }
    
    func createBookShelfPage(){
//        stopRandomBubbles()
//        currentState = .bookshelfHome
        bookshelfPage = BookshelfPage(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(bookshelfPage)
        bookshelfPage.fillSuperview()
//        bookshelfPage.delegate = self
        
        createButtonPresses()
        
        setupStoryIconDelegates()
        //        bookshelfPage.templeton.addTarget(self, action: #selector(handleTempletonTap), for: .touchUpInside)
        
        //        setupDelegates()
    }
    
    func createDonatePopUpView(){
        
        let safe = view.safeAreaLayoutGuide
        
        donatePopUpView = DonatePopUpView()
        donatePopUpView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(donatePopUpView)
        bookshelfPage.touchEnabled = false
        
        donatePopUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        donatePopUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        donatePopUpView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: view.frame.width/7).isActive = true
        donatePopUpView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -view.frame.width/7).isActive = true
        donatePopUpView.topAnchor.constraint(equalTo: safe.topAnchor, constant: view.frame.height/6).isActive = true
        donatePopUpView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -view.frame.height/6).isActive = true

        
        donatePopUpView.cancelButton.addTarget(self, action: #selector(handleDonateCancel), for: .touchUpInside)
        
        // Add a tap to dismiss the donation view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBlockingOverlayTap))
        bookshelfPage.touchBlockingOverlay.addGestureRecognizer(tap)
        
        donatePopUpView.oneDollarButton.addTarget(self, action: #selector(handleDonationTap), for: .touchUpInside)
        donatePopUpView.twoDollarButton.addTarget(self, action: #selector(handleDonationTap), for: .touchUpInside)
        donatePopUpView.fiveDollarButton.addTarget(self, action: #selector(handleDonationTap), for: .touchUpInside)
        donatePopUpView.tenDollarButton.addTarget(self, action: #selector(handleDonationTap), for: .touchUpInside)

    }

    @objc func handleBlockingOverlayTap(_ sender: UITapGestureRecognizer){
        removeDonatePopUpView()
    }
    
    @objc func handleTempletonTap(_ sender: UIButton){
        bookshelfPage.fadeAndRemove(time: 1.0)
    }

    func removeDonatePopUpView(){
        bookshelfPage.touchEnabled = true
        if donatePopUpView.superview != nil {
            donatePopUpView.shrinkAndRemove(time: 0.3)
        }
    }
    
    @objc func handleDonateCancel(_ sender: UIButton){
        removeDonatePopUpView()
    }
    
    func loadUpStory(_ name: String) {
        switch name {
        case "templtonThumbnail":
//            loadUpTempleton()
            print("it's templeton")
        default:
            print("It's not templeton!")
            createDonatePopUpView()
        }
    }
    
    @objc func handleFiveDollarDonation(_ sender: UIButton){
        workingIAPProduct.shared.makePurchase(productType: .fiveDollarDonation)
    }
    
    @objc func handleDonationTap(_ sender: UIButton){
        let button = sender as! DonateButton
        
        switch button.name {
        case "$1":
            workingIAPProduct.shared.makePurchase(productType: .oneDollarDonation)
        case "$2":
            workingIAPProduct.shared.makePurchase(productType: .twoDollarDonation)
        case "$5":
            workingIAPProduct.shared.makePurchase(productType: .fiveDollarDonation)
        case "$10":
            workingIAPProduct.shared.makePurchase(productType: .tenDollarDonation)
        default:
            return
        }
    }
    
    func createButtonPresses(){
        for view in bookshelfPage.stackViewTop!.subviews {
            let v = view as! StoryIconNew
            v.button.addTarget(self, action: #selector(handleIconPress), for: .touchUpInside)
        }
        for view in bookshelfPage.stackViewBottom!.subviews {
            let v = view as! StoryIconNew
            v.button.addTarget(self, action: #selector(handleIconPress), for: .touchUpInside)
        }
    }
    
    
    @objc func handleIconPress(_ sender: UIButton){
        let v = sender.superview as! StoryIconNew
        
        switch v.name {
            case "templetonThumbnail":
                showTempleton()
            default:
                createDonatePopUpView()
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
}

