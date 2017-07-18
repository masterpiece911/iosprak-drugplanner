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

        let nc = NotificationCenter.default
        
        nc.addObserver(forName: Notification.Name(rawValue: LoginStrings.REGISTER_SUCCESS), object: nil, queue: nil, using: registerUserSuccess)
        nc.addObserver(forName: Notification.Name(rawValue: LoginStrings.REGISTER_FAILED), object: nil, queue: nil, using: registerUserFailed)
    
        nc.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
            displayMyAlert(title: "Alert", message: "All fields are required")
            
            return
        }
        
        // Check if passwords match
        if(password != passwordRepeat){
            //Display alert message
            displayMyAlert(title: "Alert", message: "Passwords don't match")
            
            return
        }
        
        
        User.instance.register(with: email, with: password)
        
        
    }
    
    func registerUserSuccess(notification: Notification) {
        
        let usermail = notification.object as! String
        
        displayMyAlert(title: "Success!", message: "\(usermail) created")
        
        performSegue(withIdentifier: "returnToLogin", sender: self)
        
    }
    
    func registerUserFailed(notification: Notification) {
        
        let errormessage = notification.object as! String
        
        displayMyAlert(title: "Alert", message: errormessage)
        
    }
    
    
    func displayMyAlert(title: String, message:String)
    {
        
        let myAlert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        
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
