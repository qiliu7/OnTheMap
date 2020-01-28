//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Kappa on 2020-01-27.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func showAlert(title: String?, message: String?) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertVC.addAction(action)
    self.present(alertVC, animated: true, completion: nil)
  }
}
