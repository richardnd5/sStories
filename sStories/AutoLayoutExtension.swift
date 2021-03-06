import UIKit

// Thank you Brian Voong of "Let's Build That App!"!
extension UIView {
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false

        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, bottom: superview?.bottomAnchor)
    }
    
    func anchorSize(to view: UIView){
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func centerXAndSize(size: CGSize, top: NSLayoutYAxisAnchor, topPadding: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: (superview?.centerXAnchor)!).isActive = true
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true

        
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?,  padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // if the initial auto layouts have been initiated, do these. If not, go to the size conditionals and fulfill those.
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
}
