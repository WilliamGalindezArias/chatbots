//
//  ViewController.swift
//  bankApp2
//
//  Created by galwi05 on 19/09/2018.
//  Copyright © 2018 galwi05. All rights reserved.
//

import UIKit
import MASFoundation

class ViewController: UIViewController {

    // Lifecycle of the View: Was created once
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = "galwi05"
        passwordTextField.text = "7layer"
        
        
        MAS.start(withDefaultConfiguration: true) { (completed, error) in
            
            if completed {
                print("SDK Started")
            }
            else {
                print("SDK did not Start")
            }
            
        }
    }
    // LifeCycle of the view, will re appear because will be called back from other view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func logInAction(_ sender: Any) {
        
        print("log in was pressed ")
        MASUser.login(withUserName: usernameTextField.text!, password: passwordTextField.text!) { (Completed, Error) in
            if Completed {
                print("completed the log in ")
            } else {
                print("didnt log in ")
            }
            //NSNotification.Name.MASUserWillAuthenticate
            //NSNotification.Name.MASUserDidFailToAuthenticate
            //NSNotification.Name.MASUserDidAuthenticate
        }
    }

    
}


