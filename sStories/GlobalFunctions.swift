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

extension UIImage {
    func setOpacity(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
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

// For testing, to avoid having to catch all melodies
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




