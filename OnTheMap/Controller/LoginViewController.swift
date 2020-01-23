//
//  ViewController.swift
//  OnTheMap
//
//  Created by Kappa on 2020/1/22.
//  Copyright © 2020 qi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpTextView: UITextView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func loginButtonTapped(_ sender: Any) {
    OTMClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (success, error) in
      if success {
        print("success")
        //TODO: perform segue
      } else {
        print(error!)
        //TODO: show failure alert
      }
    }
  }

  
  
  
  func setupUI() {
    loginButton.layer.cornerRadius = loginButton.frame.height/8
    
    let prompt = "Don't have an account? Sign Up"
    let attributedString = NSMutableAttributedString(string: prompt)
    attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0), range: NSRange(0..<prompt.count))
    attributedString.addAttribute(.link, value: OTMClient.Endpoints.signUp, range: NSRange(23..<prompt.count))
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(0..<prompt.count))
    signUpTextView.attributedText = attributedString
  }
}

