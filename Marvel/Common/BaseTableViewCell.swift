//
//  BaseTableViewCell.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.
//

import UIKit
import Kingfisher

class BaseTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgCharacter: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfigure(character:CharacterModel) {
        
        lblName.text = character.name
        if character.description != "" {
            lblDescription.text = character.description
        }
        else {
            lblDescription.text = "Description not available"
        }
        
        let imageUrl = URL(string:(character.thumbnail.path + "." + character.thumbnail.imageExtension))
        if let imageUrl = imageUrl {
            imgCharacter.kf.setImage(with: imageUrl)
        }
    }
}
