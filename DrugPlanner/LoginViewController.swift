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
        
        
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = mainController
        }
        

       
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
            displayMyAlertMessage(userMessage: "Both fields are required");
            
            return
        }
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if let error = error {
                    self.displayMyAlertMessage(userMessage: error.localizedDescription);
                    return
                }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "Main") as UIViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = mainController
        }
        
    }

    @IBAction func passwordReset(_ sender: Any) {
        
        if self.emailTxtFld.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTxtFld.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTxtFld.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
        
    }
    
    func displayMyAlertMessage(userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }


}
