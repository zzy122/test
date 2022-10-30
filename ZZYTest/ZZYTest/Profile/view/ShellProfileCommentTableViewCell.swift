

import UIKit

class ShellProfileCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateBackView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        firstImage.createCorneradius(cornerWidth: 28, corners: .allCorners)
        secondImage.createCorneradius(cornerWidth: 28, corners: .allCorners)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickLeftBtn(_ sender: Any) {
    }
    @IBAction func clickRightBtn(_ sender: Any) {
    }
}
