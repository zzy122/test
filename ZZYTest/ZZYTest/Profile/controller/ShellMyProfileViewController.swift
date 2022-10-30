
import UIKit

class ShellMyProfileViewController: UIViewController {
    let myView:ShellMyProfileView = ShellMyProfileView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addSubview(self.myView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.myView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }
}
