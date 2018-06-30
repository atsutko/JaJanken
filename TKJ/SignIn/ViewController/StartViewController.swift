//
//  StartViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/08.
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

class StartViewController: UIViewController, LTMorphingLabelDelegate, UITextFieldDelegate, GIDSignInDelegate {
    
    var titleTextArray = ["Tataite Kabutte JankenPong", "叩いてかぶってジャンケンポン！"]
    var index: Int = 0
   
    var timer: Timer?
    
    var dict : [String : AnyObject]!

    
    @IBOutlet weak var titleMorphingLabel: LTMorphingLabel!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var facebookIconLabel: UILabel!
    @IBOutlet weak var twitterIconLabel: UILabel!
    @IBOutlet weak var googleIconLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        GIDSignIn.sharedInstance().delegate = self
        
        gradation.gradation(view: self.view)
        
        facebookIconLabel.attributedText = FAKFontAwesome.facebookIcon(withSize: 15).attributedString()
        facebookIconLabel.textColor = UIColor.white
        twitterIconLabel.attributedText = FAKFontAwesome.twitterIcon(withSize: 15).attributedString()
        twitterIconLabel.textColor = UIColor.white
        googleIconLabel.attributedText = FAKFontAwesome.googleIcon(withSize: 15).attributedString()
        googleIconLabel.textColor = UIColor.white
        
        
        titleMorphingLabel.font = UIFont(name: "Billabong", size: 20)
        titleMorphingLabel.morphingEffect = .scale

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateTitleLabel(timer:)), userInfo: nil, repeats: true)
        
        timer?.fire()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        timer?.invalidate()
    }
    
    
    func textFieldShouldReturn(_ textField: HoshiTextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func updateTitleLabel(timer: Timer) {
        titleMorphingLabel.text = titleTextArray[index]
        
        index += 1
        if index >= titleTextArray.count {
            index = 0
        }
    }
    
    
   
    
    
    @IBAction func signIn() {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
           
            SVProgressHUD.showError(withStatus: "未記入の項目があります。記入してください。")


        } else {
            
          Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                   
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                   
                    
                } else {
                    
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                  
                }
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
    
    @IBAction func facebookLoginButtonPushed() {
       
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
    
    @IBAction func twitterLogin() {
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: Key.twitterConsumerKey, consumerSecret: Key.twitterConsumerSecret)
        
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            let authentication = user.authentication
            let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
            
            Auth.auth().signIn(with: credential) { (user, error) in
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
            }
        } else {
            
        }
    }
    
    @IBAction func googleLogin() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
    }
    
    @IBAction func forgotPassward() {
        self.performSegue(withIdentifier: "toForget", sender: nil)
    }
    
    @IBAction func toSignUp() {
        self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    
    
   
}
