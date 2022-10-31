
import UIKit
import MGSwipeTableCell

class ShellChatListTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var avarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avarImage.createCorneradius(cornerWidth: 27, corners: UIRectCorner.allCorners)
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.unreadCountLabel.createCorneradius(cornerWidth: self.unreadCountLabel.bounds.height / 2.0, corners: UIRectCorner.allCorners)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
