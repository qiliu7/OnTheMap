//
//  LocationPosingController+Keyboard.swift
//  OnTheMap
//
//  Created by Kappa on 2020-02-03.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

// MARK: Move the view accoding to whether keyboard shows
extension LocationPostingViewController {
  
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func unsubscribeToKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if mediaURLTextField.isFirstResponder {
      view.frame.origin.y -= getKeyboradHeight(notification)/2
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    view.frame.origin.y = 0
  }
  
  private func getKeyboradHeight(_ notification: Notification) -> CGFloat {
    let info = notification.userInfo
    let keyboardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.cgRectValue.height
  }
  
}
