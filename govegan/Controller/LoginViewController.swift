//
//  LogInViewController.swift
//  govegan
//
//  Created by Mosma on 13/05/2021.
//

import UIKit
import AuthenticationServices
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Internal functions
    
    // Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        backButton.setup()
        
        if #available(iOS 13.0, *) {
            setupSignInButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var backButton: BackButton!
    
    // MARK: - IBActions
    @IBAction func didTapOnBackButton(_ sender: Any) {
        
        //Go back to previous controller
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Private functions
    
    @available(iOS 13.0, *)
    @objc private func handleWithSignInWithAppleTapped() {
        performSignIn()
    }
    
    @available(iOS 13.0, *)
    private func setupSignInButton() {
        
        // Instantiate ASAuthorizationAppleIDButton as soon as the view appears (viewDidLoad)
        let button = ASAuthorizationAppleIDButton()
        
        view.addSubview(button)
        defineTheConstraintsOf(button)
        // the function that will be executed when user tap the button
        button.addTarget(self, action: #selector(handleWithSignInWithAppleTapped), for: .touchUpInside)
    }
    
    /// Define the constraints of the SignInButton
    @available(iOS 13.0, *)
    private func defineTheConstraintsOf(_ signInButton: ASAuthorizationAppleIDButton) {
        
        // set this so the button will use auto layout constraint
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Disable default constraints
        signInButton.constraints.forEach { (constraint) in
            constraint.isActive = false
        }
        
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ])
    }
    
    ///
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
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user {
                    print("Nice! You're now signed in as \(user.uid), email: \(user.email ?? "unknown ")")
                }
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
