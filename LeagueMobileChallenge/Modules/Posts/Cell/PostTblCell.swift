
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//



import UIKit
import SDWebImage
class PostTblCell: UITableViewCell {
    
    //MARK: -  Outlets
    
    @IBOutlet weak var vwOut: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - Variable Declaration
    
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var cellViewModel: PostCellViewModel? {
        // Set values in cell
        didSet {
            lblTitle.text = cellViewModel?.title
            lblUserName.text = cellViewModel?.username
            imgAvatar.sd_setImage(with: URL(string: cellViewModel!.image))
            lblDescription.text = cellViewModel?.desc
        }
    }
    
    //MARK: - Initialization Method
    
    func initView() {
        // Cell view customization
        backgroundColor = .clear
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height/2
        preservesSuperviewLayoutMargins = false
        vwOut.layer.cornerRadius = 10
    }
    
    //MARK: - Default Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()    // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        lblTitle.text = nil
        lblUserName.text = nil
        lblDescription.text = nil
    }
}
