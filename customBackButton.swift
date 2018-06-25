
let appearance = UINavigationBar.appearance()
        var backImage = UIImage(named: "Back")!
        UIGraphicsBeginImageContextWithOptions(CGSize(width: backImage.size.width + 10, height: backImage.size.height), false, 0)
        backImage.draw(at: CGPoint(x: 10, y: 0))
        backImage = UIGraphicsGetImageFromCurrentImageContext()!
         UIGraphicsEndImageContext()
        appearance.backIndicatorImage = backImage
        appearance.backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setTitlePositionAdjustment(UIOffset(horizontal: -64, vertical:0), for: .default)
        
        
//////
extension UIViewController{
func setBlankBackTitleForNextVC(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem()
}
