import UIKit
import Foundation

// Function to downsample an image to save memory!!
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
