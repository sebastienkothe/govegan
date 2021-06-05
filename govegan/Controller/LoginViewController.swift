//
//  LogInViewController.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import AuthenticationServices
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    // MARK: - Internal properties
    
    /// Contains manually entered user data
    var userData: [String]?

    // MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        firestoreManager.delegate = self
        
        
        if let token = AccessToken.current, !token.isExpired {
            // User is logged in
            
        } else {
            
            // If user already connected go to create facebookLoginButton
            buttonsStackView.addArrangedSubview(facebookLoginButton)
            facebookLoginButton.delegate = self
        }
        
        if #available(iOS 13.0, *) {
            appleLoginButton.isHidden = false
            setupStackViewConstraints()
            setupSignInWithAppleButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var appleLoginButton: LoginButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    // MARK: - IBActions
    
    /// Leave the choice to the user to connect if he already has an account by returning to the home page
    @IBAction func didTapOnRegisterNowButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /// Used to close the keyboard when the user taps the screen
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    /// Handle email/password connection
    @IBAction func didTapOnLoginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, email.trimmingCharacters(in: .whitespaces) != "" else {
            UIAlertService.showAlert(style: .alert, title: "Mail required", message: "Enter your email adress")
            return
        }
        
        guard let password = passwordTextField.text, password.trimmingCharacters(in: .whitespaces) != ""else {
            UIAlertService.showAlert(style: .alert, title: "Password required", message: "Enter a password")
            return
        }
        
        handleEmailAndPasswordConnection(email, password)
    }
    
    /// Handle Facebook connection
    @IBAction func didTapOnFacebookLogin() {
        guard let currentAccessToken = AccessToken.current else {
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: currentAccessToken.tokenString)
        
        handleFacebookConnection(credential)
    }
    
    // MARK: - Private properties
    private let firestoreManager = FirestoreManager()
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    // MARK: - Private functions
    private func handleEmailAndPasswordConnection(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            
            guard error == nil else {
                // Show account creation
                self?.showCreateAccount(email: email, password: password)
                return
            }
            
            self?.emailTextField.resignFirstResponder()
            self?.passwordTextField.resignFirstResponder()

            
            self?.performSegue(withIdentifier: "segueToDashboardTabBarController", sender: nil)
        }
    }
    
    // MARK: Email/password connection
    private func showCreateAccount(email: String, password: String) {
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let okay = UIAlertAction(title: "Continue", style: .default) {_ in
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                
                guard error == nil else {
                    guard let error = error else { return }
                    UIAlertService.showAlert(style: .alert, title: "Error", message: error.localizedDescription)
                    return
                }
                
                self?.emailTextField.resignFirstResponder()
                self?.passwordTextField.resignFirstResponder()
                
                guard let userID = result?.user.uid else { return }
                guard let username = self?.userData?[0], let veganStartDate = self?.userData?[1] else { return }
                
                self?.firestoreManager.addDocumentFrom(uid: userID, username: username, veganStartDate: veganStartDate)
            }
        }
        
        UIAlertService.showAlert(style: .alert, title: "Create Account", message: "Would you like to create account ?", actions: [okay, cancel], completion: nil)
    }
    
    // MARK: Facebook connection
    private func handleFacebookConnection(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
            
            guard error == nil else {
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                UIAlertService.showAlert(style: .alert, title: "Login error", message: error?.localizedDescription, actions: [okayAction])
                return
            }
            
            guard let user = authDataResult?.user else { return }
            guard let username = self?.userData?[0], let veganStartDate = self?.userData?[1] else { return }
            
            let currentUser = User(name: username, veganStartDate: veganStartDate, userID: user.uid, email: user.email ?? "unknown")
            
            self?.performSegue(withIdentifier: "segueToDashboardTabBarController", sender: currentUser)
        }
    }
    
    private func setupStackViewConstraints() {
        buttonsStackView.constraints.forEach { (constraint) in
            let constraintToRemove = constraint.identifier == "buttonsStackViewHeight"
            if constraintToRemove {
                buttonsStackView.removeConstraint(constraint)
                buttonsStackView.addConstraint(buttonsStackView.heightAnchor.constraint(equalToConstant: 160))
            }
        }
    }
    
    @available(iOS 13.0, *)
    @objc private func handleWithSignInWithAppleTapped() {
        performSignIn()
    }
    
    /// Creation and configuration of the sign in Apple button
    @available(iOS 13.0, *)
    private func setupSignInWithAppleButton() {
        
        defineTheConstraintsOf(appleLoginButton)
        
        // the function that will be executed when user tap the button
        appleLoginButton.addTarget(self, action: #selector(handleWithSignInWithAppleTapped), for: .touchUpInside)
    }
    
    /// Define the constraints of the sign in Apple button
    @available(iOS 13.0, *)
    private func defineTheConstraintsOf(_ signInButton: UIButton) {
        
        // Disable default constraints
        signInButton.constraints.forEach { (constraint) in
            constraint.isActive = false
        }
    }
    
    @available(iOS 13.0, *)
    private func performSignIn() {
        
        let request = createAppleIDRequest()
        
        // Instantiate the authorization controller
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        // Set the delegate
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        // Kick off the login process
        authorizationController.performRequests()
    }
    
    // We create an ASAuthorizationAppleIDRequest, which includes the scopes you’re requesting as well as the hashed nonce.
    @available(iOS 13.0, *)
    private func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        // We first ask the Apple ID authorization provider to create a new request for us
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        // By specifying the email and full name scopes we tell the API that we're interested in these pieces
        request.requestedScopes = [.fullName, .email]
        
        // Now, let's generate the nonce, compute the hash, and store it in the authentication request and finally store the raw nonce in a local variable
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
}

// Used for handling the authentication callbacks
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        // Extract the authorization credential provided by Apple
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Make sure that the current nonce is set
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent")
            }
            
            // Retrieve the ID token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            // Convert ID token into a string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Create an identifier representing the user who has just connected
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
                
                guard let user = authDataResult?.user else { return }
                
                guard let username = self?.userData?[0], let veganStartDate = self?.userData?[1] else { return }
                
                let currentUser = User(name: username, veganStartDate: veganStartDate, userID: user.uid, email: user.email ?? "unknown")
                
                self?.performSegue(withIdentifier: "segueToDashboardTabBarController", sender: currentUser)
            }
        }
    }
}

// Used to handling the presentation context
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        // This lets us specify which window should host the authorization controller
        return self.view.window!
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce

// We will compute a random string that helps us to prevent replay attacks

/// Used to generate a secure nonce (number used once)
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

import CryptoKit

// Unhashed nonce.
fileprivate var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension LoginViewController: FirestoreManagerDelegate {
    func operationFirestoreCompletedWith(error: Error?) {
        guard error == nil else {
            UIAlertService.showAlert(style: .alert, title: "Error", message: error?.localizedDescription)
            return
        }
        
        print("No error, go to segueToDashboardTabBarController")
        performSegue(withIdentifier: "segueToDashboardTabBarController", sender: nil)
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with Facebook")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        Auth.auth().signIn(with: credential, completion: { authDataResult, error in
            
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}
}
