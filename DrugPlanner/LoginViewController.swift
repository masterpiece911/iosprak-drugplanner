//
//  LoginViewController.swift
//  DrugPlanner
//
//  Created by Elena Karypidou on 08.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: Notification.Name(LoginStrings.LOGIN_SUCCESS), object: nil, queue: nil, using: userLoginSuccess)
        nc.addObserver(forName: Notification.Name(LoginStrings.LOGIN_FAILED), object: nil, queue: nil, using: userLoginFailed)
        
        nc.addObserver(forName: Notification.Name(LoginStrings.PASSWORD_RESET_SUCCESS), object: nil, queue: nil, using: passwordResetSuccess)
        nc.addObserver(forName: Notification.Name(LoginStrings.PASSWORD_RESET_FAILED), object: nil, queue: nil, using: passwordResetFailed)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginBtnTapped(_ sender: Any) {
        let email = emailTxtFld.text;
        let password = passwordTxtFld.text;
        
        // Check for empty fields
        
        if((email?.isEmpty)! || (password?.isEmpty)!){
            
            // Display alert message
            displayMyAlert(alertTitle: "Alert", message: "Both fields are required")
            return
        }
        
        User.instance.login(with: email!, with: password!)
        
    }
    
    func userLoginSuccess(notification: Notification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainController
    }
    
    func userLoginFailed(notification: Notification) {
        
        let alertMessage = notification.object as! String
        displayMyAlert(alertTitle: "Alert", message: alertMessage)
        
    }

    @IBAction func passwordReset(_ sender: Any) {
        
        if self.emailTxtFld.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            User.instance.resetPassword(of: emailTxtFld.text)
        }
        
    }
    
    func passwordResetSuccess (notification : Notification) {
        displayMyAlert(alertTitle: "Success!", message: "Password reset mail sent.")
        self.emailTxtFld.text = ""
    }
    
    func passwordResetFailed (notification : Notification) {
        
        let errormessage = notification.object as! String
        displayMyAlert(alertTitle: "Alert", message: errormessage)
        self.emailTxtFld.text = ""
    }
    
    func displayMyAlert(alertTitle: String, message:String) {
        
        let myAlert = UIAlertController(title:alertTitle, message:message, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }

    @IBAction func returnToLogin(segue: UIStoryboardSegue) {
        
    }
    
}
