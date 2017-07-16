//
//  LoginDB.swift
//  DrugPlanner
//
//  Created by Sahin on 13.07.17.
//  Copyright © 2017 Gruppe 9. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    static let instance = User()
    
    var ID : String?
    
    let nc = NotificationCenter.default
    
    private init() {
        
        if let userID = Auth.auth().currentUser?.uid {
            self.ID = userID
        } else {
            self.ID = nil
        }
        
    }
    
    func login(with mail: String!, with password: String!) {
        
        Auth.auth().signIn(withEmail: mail, password: password) {
            (user, error) in
            if let error = error {
                self.nc.post(name: Notification.Name(rawValue: LoginStrings.LOGIN_FAILED), object: error.localizedDescription)
                return
            }

            self.ID = Auth.auth().currentUser?.uid
            self.nc.post(name: Notification.Name(rawValue: LoginStrings.LOGIN_SUCCESS), object: nil)
            
        }
        
    }
    
    func logout() {
        do{
            try Auth.auth().signOut()
            self.nc.post(name: Notification.Name(rawValue: LoginStrings.LOGOUT_SUCCESS), object: nil)
        } catch let logOutError as NSError {
            self.nc.post(name: Notification.Name(rawValue: LoginStrings.LOGOUT_FAILED), object: logOutError)
        }
    }
    
    func register(with mail: String!, with password: String!) {
        
        Auth.auth().createUser(withEmail: mail, password: password) {
            (user, error) in
            if let error = error {
                self.nc.post(name: Notification.Name(rawValue: LoginStrings.REGISTER_FAILED), object: error.localizedDescription)
                return
            }
            
            self.nc.post(name: Notification.Name(rawValue: LoginStrings.REGISTER_SUCCESS), object: user?.email)
        }
    }
    
    func resetPassword(of mail: String!) {
        
        Auth.auth().sendPasswordReset(withEmail: mail) {
            error in
            if let error = error {
                self.nc.post(name: Notification.Name(rawValue: LoginStrings.PASSWORD_RESET_FAILED), object: error.localizedDescription)
            }
            
            self.nc.post(name: Notification.Name(rawValue: LoginStrings.PASSWORD_RESET_SUCCESS), object: nil)
        }
    }
    
}
