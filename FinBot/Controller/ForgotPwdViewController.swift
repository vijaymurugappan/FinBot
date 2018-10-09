//
//  ForgotPwdViewController.swift
//  FinBot
//
//  Created by Vijay Murugappan Subbiah on 8/23/18.
//  Copyright © 2018 VMS. All rights reserved.
//

import UIKit
import Firebase

class ForgotPwdViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBAction func forgotClicked(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: userTextField.text!, completion: {
            error in
            if ((error) != nil) {
                self.showAlert(Title: "INVALID", Desc: "User does not exist")
            }
            self.dismiss(animated: true, completion: nil)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "FORGOT PASSWORD"
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        userTextField.text = ""
        userTextField.resignFirstResponder()
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
