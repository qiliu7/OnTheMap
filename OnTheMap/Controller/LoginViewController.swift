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
    
    let prompt = "Don't have an account? Sign Up"
    let attributedString = NSMutableAttributedString(string: prompt)
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0), range: NSRange(0..<prompt.count))
    attributedString.addAttribute(.link, value: Client.Endpoints.signUp, range: NSRange(23..<prompt.count))
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(0..<prompt.count))
    signUpTextView.attributedText = attributedString
  }
}

