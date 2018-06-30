//
//  EditUserViewController.swift
//  TKJ
//
//  Created by TakaoAtsushi on 2018/06/24.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import Firebase
import NYXImagesKit
import Kingfisher
import SCLAlertView

class EditUserViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var introductionTextView: UITextView!
    
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    var uploadImage: UIImage?
    var ref = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        profImageView.layer.cornerRadius = profImageView.bounds.width / 2.0
        profImageView.layer.masksToBounds = true
        
        userNameTextField.delegate = self
        introductionTextView.delegate = self
        
        self.imagePicker.delegate = self
        
        readProfile()
        //TODO:FireBaseを用いて、ユーザー情報を表示。
        
        /*
        if let user = NCMBUser.current() {
            userNameTextField.text = user.object(forKey: "displayName") as? String
            userIdTextField.text = user.userName
            introductionTextView.text = user.object(forKey: "introduction") as? String
            
            let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil {
                    let alert = UIAlertController(title: "画像取得エラー", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if data != nil {
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                }
            }
        } else {
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
 */
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
/*
    func fileupload(deta: UIImage) {
        let storage = Storage.storage().reference(forURL: "gs://tkjp-38f43.appspot.com")
        //ディレクトリを指定
        let imageRef = storage.child("User").child("image.jpg")
        //保存を実行して、metadataにURLが含まれているので、あとはよしなに加工
        let imageData = UIImageJPEGRepresentation(deta, 1.0)!
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if error != nil {
                
            } else {
                //URL型をNSstring型に変更
                let downloadURL = metadata!.downloadURL()
                
                let data = downloadURL?.absoluteString
                let ref = Database.database().reference()
                ref.child("User").child(self.userID!).updateChildValues(["profile": data])
            }
        }
    }
 */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let resizedImage = selectedImage.scale(byFactor: 0.4)
            self.uploadImage = resizedImage
            
            picker.dismiss(animated: true, completion: nil)
        } else {
            
        }
        
        
        
        
        
        /*
        let data = UIImagePNGRepresentation(resizedImage!)
        let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil {
                let alert = UIAlertController(title: "画像アップロードエラー", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.userImageView.image = selectedImage
            }
        }) { (progress) in
            print(progress)
        }*/
        
    }
    
    func createImage(uploadImage: UIImage) {
        let uploadData: Data = UIImagePNGRepresentation(uploadImage)!
        ref.child((Auth.auth().currentUser?.uid)!).putData(uploadData, metadata: nil) { (data, error) in
            if error != nil {
                
            }else {
                
            }
        }
    }
    
    func readProfile() {
        let gsReference = Storage.storage().reference(forURL: "gs://tkjp-38f43.appspot.com")
        gsReference.child((Auth.auth().currentUser?.uid)!).getData(maxSize: 1 * 1028 * 1028) { (data, error) in
            if error != nil {
                //プロフィール画像が読み込めない。
            } else {
                //プロフィールの読み込み完了
                self.uploadImage = UIImage(data: data!)
                self.profImageView.image = self.uploadImage
            }
        }
    }
    
    
    @IBAction func selectProfImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラが使用出来ません。")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            // アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func selectBackgroundImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "選択して下さい", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラが使用出来ません。")
            }
        }
        let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            // アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            actionController.dismiss(animated: true, completion: nil)
        }
        actionController.addAction(cameraAction)
        actionController.addAction(albumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    
    @IBAction func closeEditViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func OKButtonPushed() {
        // userのアクティブ状態を変更できたらログイン画面に移動
        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        
        // ログイン状態の保持
        let ud = UserDefaults.standard
        ud.set(false, forKey: "isLogin")
        ud.synchronize()
    }
    
    @IBAction func saveUserInfo() {
        if let user = Auth.auth().currentUser {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.userNameTextField.text
            
        } else {
            //ユーザーがログインしていない状態
            let alertView: SCLAlertView = SCLAlertView()
            alertView.addButton("OK", target: self, selector: #selector(EditUserViewController.OKButtonPushed))
            alertView.showError("ユーザーログイン", subTitle: "ログインしなおしてください")
        }
        
        
     /*   let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey: "displayName")
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.setObject(introductionTextView.text, forKey: "introduction")
        user?.saveInBackground({ (error) in
            if error != nil {
                let alert = UIAlertController(title: "送信エラー", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })*/
    }
    
    

 

}
