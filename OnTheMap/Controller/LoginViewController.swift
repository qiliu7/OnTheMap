//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpTextView: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    
    loginButton.layer.cornerRadius = loginButton.frame.height/8

    let signUpString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
    signUpString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0), range: .init(location: 0, length: 30))
    signUpString.addAttribute(.link, value: "https://auth.udacity.com/sign-up", range: NSRange(location: 23, length: 7))
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    signUpString.addAttribute(.paragraphStyle, value: style, range: .init(location: 0, length: 30))
    signUpTextView.attributedText = signUpString
  }
}

