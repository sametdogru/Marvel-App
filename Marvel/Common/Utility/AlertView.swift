
//  AlertView.swift
//  Marvel
//
//  Created by Samet Doğru on 14.03.2022.

import Foundation
import UIKit

protocol AlertDelegate {
    func tryAgain(controller:UIViewController)
}

class AlertView {
    
    var delegate: AlertDelegate?
    
    func showAlertView(alertTitle:String,alertMsg:String,view:UIViewController) {
        let alert = UIAlertController(title:alertTitle, message:alertMsg, preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated:true, completion:nil)
    }
    
    func showAlertViewWithReload(view:UIViewController) {
        delegate = view as? AlertDelegate
        let alertController = UIAlertController(title: "Alert", message: "No Internet Connection", preferredStyle: UIAlertController.Style.alert)
        let tryAgainAction = UIAlertAction(title:"Try Again", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print(view)
            self.delegate?.tryAgain(controller:view)
        }
        alertController.addAction(tryAgainAction)
        view.present(alertController, animated: true, completion: nil)
    }
}


