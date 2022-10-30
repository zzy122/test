
import UIKit

class ShellProfileMakeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avarImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avarImage.createCorneradius(cornerWidth: 24, corners: .allCorners)
        // Initialization code
    }

}
