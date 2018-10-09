//
//  SignUpViewController.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 8/23/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var rePasswordTV: UITextField!
    @IBOutlet weak var nameTv: UITextField!
    
    
    @IBAction func signupClicked(_ sender: UIButton) {
        if userTextField.text == "" || passwordTextField.text == "" {
            showAlert(Title: "INVALID", Desc: "Please enter username and password")
            return
        }
        if isValidEmail(testStr: userTextField.text!) && doesPasswordMatch(testStr: passwordTextField.text!, testStr2: rePasswordTV.text!) {
            Auth.auth().createUser(withEmail: userTextField.text!, password: passwordTextField.text!, completion: {
                (user,error) in
                if(error == nil) {
                    let ref = Database.database().reference(fromURL: "https://clerkiecc.firebaseio.com/")
                    let userRef = ref.child("Users").child((user?.user.uid)!)
                    let values = ["email": self.userTextField.text!, "name": self.nameTv.text!, "januaryE": Int.random(in: 100...350), "febrauryE": Int.random(in: 100...350), "marchE": Int.random(in: 100...350), "aprilE": Int.random(in: 100...350), "mayE": Int.random(in: 100...350), "juneE": Int.random(in: 100...350), "julyE": Int.random(in: 100...350), "augustE": Int.random(in: 100...350), "septemberE": Int.random(in: 100...350), "octoberE": Int.random(in: 100...350), "novemberE": Int.random(in: 100...350), "decemberE": Int.random(in: 100...350), "januaryS": Int.random(in: 100...350), "febrauryS": Int.random(in: 100...350), "marchS": Int.random(in: 100...350), "aprilS": Int.random(in: 100...350), "mayS": Int.random(in: 100...350), "juneS": Int.random(in: 100...350), "julyS": Int.random(in: 100...350), "augustS": Int.random(in: 100...350), "septemberS": Int.random(in: 100...350), "octoberS": Int.random(in: 100...350), "novemberS": Int.random(in: 100...350), "decemberS": Int.random(in: 100...350)] as [String : Any]
                    userRef.updateChildValues((values) as [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                        if err != nil {
                            self.showAlert(Title: "ERROR", Desc: (err?.localizedDescription)!)
                        }
                    })
                    self.performSegue(withIdentifier: "login", sender: self)
                    return
                }
                self.showAlert(Title: "ERROR", Desc: (error?.localizedDescription)!)
                return
            })
        }
        else if !isValidEmail(testStr: userTextField.text!) {
            self.showAlert(Title: "INVALID", Desc: "Please enter a valid email address")
            return
        }
        else if !doesPasswordMatch(testStr: passwordTextField.text!, testStr2: rePasswordTV.text!) {
            self.showAlert(Title: "MISMATCH", Desc: "Passwords doesnt match")
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationItem.title = "SIGN UP"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
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
        rePasswordTV.resignFirstResponder()
        nameTv.resignFirstResponder()
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func doesPasswordMatch(testStr: String, testStr2: String) -> Bool {
        if testStr == testStr2 {
            return true
        }
        else {
            return false
        }
    }

}
