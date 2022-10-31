
import UIKit

class ShellMyProfileHeader: UIView {

    @IBOutlet weak var selectBottonView: UIView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avarImage: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectBottonView.layer.cornerRadius = 16
        self.selectBottonView.layer.masksToBounds = true
        
        self.avarImage.layer.cornerRadius = 54
        self.avarImage.layer.masksToBounds = true
        
        self.editBtn.layer.cornerRadius = 12
        self.editBtn.layer.borderWidth = 1.0
        self.editBtn.layer.borderColor = UIColor.black.cgColor
        self.editBtn.layer.masksToBounds = true
    }
    
    
    class func createView() ->ShellMyProfileHeader {
        let result = Bundle.main.loadNibNamed("ShellMyProfileHeader", owner: self)?.first as! ShellMyProfileHeader
        
        return result
    }

}
