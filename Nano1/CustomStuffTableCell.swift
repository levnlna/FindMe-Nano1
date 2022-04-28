//
//  CustomStuffTableController.swift
//  Nano1
//
//  Created by Levina Niolana on 27/04/22.
//

import UIKit

class CustomStuffTableCell: UITableViewCell {

  @IBOutlet weak var stuffNameUI: UILabel!
  @IBOutlet weak var locationUI: UILabel!
  @IBOutlet weak var statusUI: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
