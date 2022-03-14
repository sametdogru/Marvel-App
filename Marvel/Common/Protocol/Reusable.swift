//
//  Reusable.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.
//

import Foundation
import UIKit

public protocol Reusable {
  static var reuseIdentifier: String {get}
}

public extension Reusable {
  static var reuseIdentifier: String {return String(describing: self)}
}

public extension Reusable where Self: UIViewController {
  init(bundle: Bundle?) {
    self.init(nibName: Self.reuseIdentifier, bundle: bundle)
  }
}
