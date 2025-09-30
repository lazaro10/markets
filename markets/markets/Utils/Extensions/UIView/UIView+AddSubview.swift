import UIKit

extension UIView {
    func addSubviewWithoutAutoresizingMask(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }
}
