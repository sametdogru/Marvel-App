//
//  TableViewExtension.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.

import UIKit

public extension UITableView {
  
  func register<T: UITableViewCell> (_ type: T.Type) where T: Reusable {
    let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
    register(nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
    guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Cell can't cast")
    }
    
    return cell
  }
  
  func restore() {
    self.backgroundView = nil
  }
  
  func setEmpty(message: String) {
      
      let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
      messageLabel.text = message
      messageLabel.textColor = .black
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = .center
      messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
      messageLabel.sizeToFit()

      self.backgroundView = messageLabel
  }
}

extension UITableView {
    func registerCell<T: UITableViewCell>(type: T.Type) where T: Reusable {
        self.register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)

    }

    func dequeueReusableCell<T: UITableViewCell> (forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
}
