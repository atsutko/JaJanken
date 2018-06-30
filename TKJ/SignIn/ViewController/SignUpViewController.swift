//
//  SignUpViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/16.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Firebase
import LTMorphingLabel
import FBSDKLoginKit
import SVProgressHUD
import TextFieldEffects
import TwitterKit
import FontAwesomeKit
import SCLAlertView
import GoogleSignIn


class SignUpViewController: UIViewController, GIDSignInDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var userNameTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var passConfirmTextField: HoshiTextField!
    
    @IBOutlet weak var twitterIconLabel: UILabel!
    @IBOutlet weak var facebookIconLabel: UILabel!
    @IBOutlet weak var googleIconLabel: UILabel!
    
    var dict : [String : AnyObject]!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradation.gradation(view: self.view)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        GIDSignIn.sharedInstance().delegate = self
        
        twitterIconLabel.attributedText = FAKFontAwesome.twitterIcon(withSize: 15).attributedString()
        twitterIconLabel.textColor = UIColor.white
        facebookIconLabel.attributedText = FAKFontAwesome.facebookIcon(withSize: 15).attributedString()
        facebookIconLabel.textColor = UIColor.white
        googleIconLabel.attributedText = FAKFontAwesome.googleIcon(withSize: 15).attributedString()
        googleIconLabel.textColor = UIColor.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: HoshiTextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    @IBAction func signUp() {
        if passwordTextField.text! == passConfirmTextField.text! {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                        if error != nil {
                            
                        } else {
                            
                            let ud = UserDefaults.standard
                            ud.set(true, forKey: "isSignIn")
                            ud.synchronize()
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let viewController = storyboard.instantiateInitialViewController()
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window!?.rootViewController = viewController
                            appDelegate?.window!?.makeKeyAndVisible()
                        }
                    })
                    
                } else {
                    
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "パスワードが一致していません。")
        }
        
        
        
       
    }
    
    
    @IBAction func twitterSignUp() {
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if session != nil {
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail(forCurrentUser: { (email, error) in
                    if email != nil {
                        
                        
                        let credential = TwitterAuthProvider.credential(withToken: (session?.authToken)!, secret: (session?.authTokenSecret)!)
                        
                        
                        Auth.auth().signIn(with: credential, completion: { (user, error) in
                            
                            if error != nil {
                                
                            } else {
                                
                                let ud = UserDefaults.standard
                                ud.set(true, forKey: "isSignIn")
                                ud.synchronize()
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                let viewController = storyboard.instantiateInitialViewController()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window!?.rootViewController = viewController
                                appDelegate?.window!?.makeKeyAndVisible()
                                
                            }
                        })
                        
                        
                    } else {
                        //emailが存在しない。
                        SVProgressHUD.showError(withStatus: "emailの登録がされていません。")
                    }
                })
            }
        }
    }
    
    func getFBUserData(){
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    self.dict = result as! [String : AnyObject]
                }
            })
        }
    }
    
    @IBAction func facebookSignUp() {
        
        let manager = FBSDKLoginManager()
        manager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                
            } else {
                if let res = result {
                    if res.grantedPermissions != nil {
                        if res.grantedPermissions.contains("email") == true {
                            self.getFBUserData()
                            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                            Auth.auth().signIn(with: credential, completion: { (user, error) in
                                if error != nil {
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                                    
                                    let ud = UserDefaults.standard
                                    ud.set(true, forKey: "isLogin")
                                    ud.synchronize()
                                    
                                } else {
                                    
                                }
                            })
                            manager.logOut()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func googleSignUp() {
        
    }
    
    @IBAction func dismiss() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

  

}
