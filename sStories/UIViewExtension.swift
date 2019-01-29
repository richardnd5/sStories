import UIKit

extension UIView {
    
    func fadeTo(time: Double, opacity: CGFloat, _ completion: @escaping () ->() = {} ){
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
    
    func fadeAndRemove(time: Double, completion: @escaping ( ) -> ( ) = {} ){
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
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
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
    
    func shrinkAndRemove(time: Double, _ completion: @escaping () ->() = {} ){
        
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
    
    func moveViewTo(_ point: CGPoint, time: Double, _ completion: @escaping () ->() = {} ){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.frame.origin = point
        },
            completion: {
                _ in
                completion()
        })
    }
    
    func changeSize(to: CGSize, time: Double){
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.frame.size = to
        },
            completion: {
                _ in
        })
    }
    
    func scaleTo(scaleTo: CGFloat, time: Double, _ completion: @escaping () ->() = {} ){
        
        UIView.animate(
            withDuration: time,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: scaleTo, y: scaleTo)
        },
            completion: {
                _ in
                completion()
        })
    }
}
