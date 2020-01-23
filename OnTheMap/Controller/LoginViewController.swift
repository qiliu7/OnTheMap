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
    let username = emailTextField.text ?? ""
    let password = passwordTextField.text ?? ""
    OTMClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
  }
   
  
  func handleLoginResponse(success: Bool, error: Error?) {
    if success {
      print("success")
      //TODO: perform segue
    } else {
      self.showLoginFailure(message: error?.localizedDescription ?? "")
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

  func showLoginFailure(message: String) {
    let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
    
    //TODO: should have a func to set loggingIn state
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    show(alertVC, sender: nil)
  }
}


