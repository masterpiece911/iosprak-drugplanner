//
//  RegisterViewController.swift
//  DrugPlanner
//
//  Created by Elena Karypidou on 10.06.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var passwordRepeatTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        let email = emailTxtFld.text;
        let password = passwordTxtFld.text;
        let passwordRepeat = passwordRepeatTxtFld.text;
        
        // Check for empty fields
        
        if((email?.isEmpty)! || (password?.isEmpty)! || (passwordRepeat?.isEmpty)!){
            
            
            // Display alert message
            displayMyAlertMessage(userMessage: "All fields are required");

            return
        }
        
        // Check if passwords match
        if(password != passwordRepeat){
            //Display alert message
            displayMyAlertMessage(userMessage: "Passwords do not match");

            return
        }
        
        
        // Store Data
        
            // [START create_user]
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                // [START_EXCLUDE]
                    if let error = error {
                        self.displayMyAlertMessage(userMessage: error.localizedDescription)
                        return
                    }
                    print("\(user!.email!) created")
                    self.displayMyAlertMessage(userMessage: "\(user!.email!) created")

                
                // [END_EXCLUDE]
            }
            // [END create_user]
        
        
        // Alert Message Confirmation
        
        
        
    }
    
    
    func displayMyAlertMessage(userMessage:String)
    {
        
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
