//
//  ViewController.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 10/2/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    
    var uid = String()
    var count = Int()
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if userTextField.text == "" || passwordTextField.text == "" {
            showAlert(Title: "INVALID", Desc: "Username or Password not found")
            return
        }
        
        Auth.auth().signIn(withEmail: userTextField.text!, password: passwordTextField.text!, completion: {
            (user,error) in
            if(error == nil) {
                self.uid = (user?.user.uid)!
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(self.uid, forKey: "userID")
                UserDefaults.standard.synchronize()
                UIView.setAnimationsEnabled(false)
                self.pushChatScreen()
                return
            }
            if(user?.user.uid == "") {
                self.showAlert(Title: "INCORRECT", Desc: "User does not exist")
                return
            }
            self.showAlert(Title: "INCORRECT", Desc: "Entered credentials are not valid")
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            self.uid = UserDefaults.standard.string(forKey: "userID")!
            UIView.setAnimationsEnabled(false)
            self.pushChatScreen()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func pushChatScreen() {
        count += 1
        let controller = ChatLogController.init(collectionViewLayout: UICollectionViewFlowLayout())
        if (count == 1) {
            controller.setupInitialMessages(inputText: "Welcome")
            controller.setupInitialMessages(inputText: "I'm Fin Bot")
            controller.setupInitialMessages(inputText: "How may i assist you today?")
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") == true {
            self.uid = UserDefaults.standard.string(forKey: "userID")!
            UIView.setAnimationsEnabled(false)
            pushChatScreen()
        }
        self.navigationController?.isNavigationBarHidden = true
        userTextField.text = ""
        passwordTextField.text = ""
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func showAlert(Title: String, Desc: String) {
        let alertController = UIAlertController(title: Title, message: Desc, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) {
            (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}



