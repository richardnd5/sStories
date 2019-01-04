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

// Function to change the opacity of a view over a set time.
func changeOpacity(view: UIView, time: Double, opacity: CGFloat, _ completion: @escaping () ->()){
    
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

//// From stackoverflow!  rmooney   odemolliens    sunshineDev     Thank you!
//extension UIView {
//    func addDashedBorder() {
//        let color = UIColor.white.cgColor
//        
//        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        let frameSize = self.frame.size
//        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//        
//        shapeLayer.bounds = shapeRect
//        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = color
//        shapeLayer.lineWidth = 1
//        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
//        shapeLayer.lineDashPattern = [6,3]
//        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
//        
//        self.layer.addSublayer(shapeLayer)
//    }
//}
