//
//  CharacterDetailsHeaderView.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.
//

import UIKit

class CharacterDetailsHeaderView: UIView {
    
    @IBOutlet weak var imgCharacter: UIImageView!
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var descCharacter: UILabel!
    
    var likeClicked: ()->() = {}

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "CharacterDetailsHeaderView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func likeButton(_ sender: Any) {
        self.likeClicked()
    }
}

extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
