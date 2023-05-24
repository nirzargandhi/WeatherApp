//
//  UIScrollViewExtension.swift
//  Rello
//

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    func scrollToTopNotchWise(animated: Bool) {
        let yAxis: CGFloat = ((UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0) ? 44 : 0
        let topOffset = CGPoint(x: 0, y: -yAxis)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: true)
    }
    
}
