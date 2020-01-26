//
//  SignInVC.swift
//  mChat
//
//  Created by Vitaliy Paliy on 11/16/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol HandleLoginViews {
    func returnToSignInVC()
}

class SignInVC: UIViewController, UITextFieldDelegate {
    
    let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    let logoTransitionView = UIView()
    
    var logoView = UIView()
    var authNetworking = AuthNetworking()
    var loginView = UIView()
    var loginButton = UIButton(type: .system)
    var emailTextField = SkyFloatingLabelTextField()
    var passwordTextField = SkyFloatingLabelTextField()
    var errorLabel = UILabel()
    var keyboardIsShown = false
    var keyBoardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientView()
        setupLoginView()
        notificationCenterHandler()
        hideKeyboardOnTap()
        setupLogo()
        view.backgroundColor = .white
        setupSignUpButton()
        animateTransition()
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func notificationCenterHandler() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification){
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }
        if !keyboardIsShown {
            keyBoardHeight = height
            view.frame.origin.y -= keyBoardHeight!
        }
        keyboardIsShown = true
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification){
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = keyBoardHeight else { return }
        view.frame.origin.y += height
        keyboardIsShown = false
        guard let duration = kDuration else { return }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
        keyboardIsShown = false
    }
    
    func setupLogo() {
        view.addSubview(logoView)
        logoView.backgroundColor = .white
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.layer.cornerRadius = 50
        logoView.layer.masksToBounds = true
        let constraints = [
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/6),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
        
    func animateTransition() {
        
        logoTransitionView.frame = view.frame
        let gradient = setupGradientLayer()
        gradient.frame = view.frame
        logoTransitionView.layer.addSublayer(gradient)
        view.addSubview(logoTransitionView)
        
        logo.center = CGPoint(x: view.center.x, y: view.center.y)
        logo.image = UIImage(named: "Logo-Light")
        logo.contentMode = .scaleAspectFit
        logo.layer.cornerRadius = 100
        logo.layer.masksToBounds = true
        view.addSubview(logo)
        
        logoLabel.center = CGPoint(x: view.center.x, y: view.center.y + 150)
        logoLabel.font = UIFont(name: "Alata", size: 48)
        logoLabel.text = "mChat"
        logoLabel.textAlignment = .center
        logoLabel.textColor = .white
        view.addSubview(logoLabel)
        
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(animateLogo), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .default)
    }
    
    @objc func animateLogo(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.logo.layer.cornerRadius = 45
            self.logo.frame.size = CGSize(width: 90, height: 90)
            self.logo.center = CGPoint(x: self.logoView.center.x, y: self.logoView.center.y)
            self.logoTransitionView.alpha = 0
            self.logoLabel.alpha = 0
        }) { (true) in
            self.logoTransitionView.removeFromSuperview()
            self.logoLabel.removeFromSuperview()
        }
    }
    
    func setupGradientView() {
        let gradientView = UIView()
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 50
        gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let constraints = [
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        let gradient = setupGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let topColor = UIColor(red: 100/255, green: 90/255, blue: 255/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 140/255, green: 135/255, blue: 255/255, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        return gradient
    }
    
    func setupLoginView() {
        view.addSubview(loginView)
        loginView.backgroundColor = .white
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.layer.cornerRadius = 8
        loginView.layer.shadowRadius = 10
        loginView.layer.shadowOpacity = 0.3
        var height: CGFloat = 280
        if view.frame.height > 1000 { height = 600 }
        let constraints = [
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginView.heightAnchor.constraint(equalToConstant: height )
        ]
        NSLayoutConstraint.activate(constraints)
        setupLoginLabel()
        setupLoginButton()
        setupEmailTextField()
        setupPasswordTextField()
        setupErrorLabel()
    }
    
    func setupLoginButton() {
        loginButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.tintColor = .white
        loginButton.layer.cornerRadius = 18
        loginButton.layer.masksToBounds = true
        let gradient = setupGradientLayer()
        gradient.frame = loginButton.bounds
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        loginButton.layer.insertSublayer(gradient, at: 0)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        let constraints = [
            loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: loginView.bottomAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupLoginLabel() {
        let loginLabel = UILabel()
        loginView.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "SIGN IN"
        loginLabel.textAlignment = .center
        loginLabel.font = UIFont.boldSystemFont(ofSize: 18)
        loginLabel.textColor = .gray
        let constraints = [
            loginLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupEmailTextField() {
        loginView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "EMAIL"
        emailTextField.delegate = self
        emailTextField.font = UIFont.boldSystemFont(ofSize: 14)
        emailTextField.selectedLineColor = AppColors.mainColor
        emailTextField.lineColor = .lightGray
        let constraints = [
            emailTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 64),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupPasswordTextField() {
        loginView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.delegate = self
        passwordTextField.font = UIFont.boldSystemFont(ofSize: 14)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.selectedLineColor = AppColors.mainColor
        passwordTextField.lineColor = .lightGray
        let constraints = [
            passwordTextField.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 120),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupErrorLabel() {
        loginView.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        let constraints = [
            errorLabel.centerXAnchor.constraint(equalTo: loginView.centerXAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func validateTF() -> String?{
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Make sure you fill in all fields"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count < 6 {
            return "Password should be at least 6 characters long"
        }
        return nil
    }
    
    func setupSignUpButton() {
        let signUpButton = UIButton(type: .system)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let mainString = "Don't have an account? Sign Up"
        let stringWithColor = "Sign Up"
        let range = (mainString as NSString).range(of: stringWithColor)
        let attributedString = NSMutableAttributedString(string: mainString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        signUpButton.tintColor = .black
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        let constraints = [
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func signUpButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            for subview in self.loginView.subviews {
                subview.alpha = 0
            }
            self.loginButton.alpha = 0
        }) { (true) in
            let controller = SignUpVC()
            controller.modalPresentationStyle = .fullScreen
            controller.signInVC = self
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    @objc func loginButtonPressed() {
        errorLabel.text = ""
        let validation = validateTF()
        if validation != nil {
            errorLabel.text = validation!
            return
        }
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        authNetworking.signInVC = self
        authNetworking.signIn(with: email, and: password) { (error) in
            self.errorLabel.text = error?.localizedDescription
        }
    }
    
}

extension SignInVC: HandleLoginViews {
    func returnToSignInVC() {
        for subview in loginView.subviews {
            subview.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        loginButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            for subview in self.loginView.subviews {
                subview.transform = .identity
                subview.alpha = 1
                self.loginButton.alpha = 1
                self.loginButton.transform = .identity
            }
        })
    }
    
    
}
