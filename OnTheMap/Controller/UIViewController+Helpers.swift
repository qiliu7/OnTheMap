//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Kappa on 2020-01-27.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlert(title: String?, message: String?, cancelable: Bool = false, okHandler: ((UIAlertAction) -> Void )? = nil) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    if cancelable {
      let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
      alertVC.addAction(cancel)
    }
    let action = UIAlertAction(title: "OK", style: .default, handler: okHandler)
    alertVC.addAction(action)
    
    present(alertVC, animated: true, completion: nil)
  }
  
  func createActivityIndicatorView() -> UIActivityIndicatorView {
    let activity = UIActivityIndicatorView(style: .large)
    activity.hidesWhenStopped = true
    activity.center = self.view.center
    activity.center.y -= self.view.frame.height/8
    return activity
  }
}
