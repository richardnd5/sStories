import UIKit
import Foundation

// Function to downsample an image to save memory!! From the WWDC 2018 talk of optimizing images
func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat)-> UIImage{
    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
    let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
    
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    let downsampleOptions =
        [kCGImageSourceCreateThumbnailFromImageAlways: true,
         kCGImageSourceShouldCacheImmediately: true,
         kCGImageSourceCreateThumbnailWithTransform: true,
         kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
    
    let downsampledImage =
        CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
    return UIImage(cgImage: downsampledImage)
}

func resizedImage(name: String, frame: CGRect, scale: CGFloat = 1) -> UIImage{
    var image : UIImage!
    let bundleURL = Bundle.main.resourceURL?.appendingPathComponent("\(name).png")
    image = downsample(imageAt: bundleURL!, to: CGSize(width: frame.width*3, height: frame.height*3), scale: 1)
    return image
}

// Function to change the opacity of a view over a set time.
func changeOpacityOverTime(view: UIView, time: Double, opacity: CGFloat, _ completion: @escaping () ->()){
    
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



func determineWhatImageToShowForMelody(type: MelodyType) -> String{
    
    var string = String()
    
    switch type {
    case .begin:
        string = "begin"
    case .middle:
        string = "middle"
    case .tonic:
        string = "tonic"
    case .dominant:
        string = "dominant"
    case .ending:
        string = "ending"
    case .final:
        string = "final"
    }
    return string
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

extension UIImage {
    func setOpacity(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIView {
    
    func fadeTo(time: Double, opacity: CGFloat, _ completion: @escaping () ->()){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alpha = opacity
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func fadeAndRemove(time: Double, completion: @escaping ( ) -> ( ) ){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alpha = 0.0
        },
            completion: {
                _ in
                completion()
                self.removeFromSuperview()
        })
    }
    
    func addDashedBorder() {
        let color = UIColor.white.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4,2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: self.frame.height/10).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func shrinkAndRemove(time: Double, _ completion: @escaping () ->()){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.00000001, y: 0.00000001)
        },
            completion: {
                _ in
                self.removeFromSuperview()
                completion()
        })
    }
    
    func moveViewTo(_ point: CGPoint, time: Double){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                
                self.frame.origin = point
        },
            completion: {
                _ in
        })
    }
}
