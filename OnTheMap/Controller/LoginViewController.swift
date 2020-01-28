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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  @IBAction func loginTapped(_ sender: Any) {
    setLoggingIn(true)
    let username = emailTextField.text ?? ""
    let password = passwordTextField.text ?? ""
    OTMClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
  }
   
  func handleLoginResponse(success: Bool, error: Error?) {
    setLoggingIn(false)
    if success {
      performSegue(withIdentifier: Constants.toLocationTabViewSegueId, sender: nil)
    } else {
      self.showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
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
  
  func setLoggingIn(_ loggingIn: Bool) {
    emailTextField.isEnabled = !loggingIn
    passwordTextField.isEnabled = !loggingIn
    loginButton.isEnabled = !loggingIn
    loggingIn ? activityIndicator.startAnimating(): activityIndicator.stopAnimating()
  }
}


