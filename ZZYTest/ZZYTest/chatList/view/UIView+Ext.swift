
import UIKit

extension UIView {
    func createCorneradius(cornerWidth:CGFloat, corners:UIRectCorner) {
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerWidth, height: cornerWidth)).cgPath
        self.layer.mask = layer
    }
}
