//
//  ViewController.swift
//  TodoWithFirebase
//
//  Created by user user on 2019/07/26.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    var uid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textEmail.text = ""
        textPassword.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textEmail.text = ""
        textPassword.text = ""
    }

    @IBAction func registerAction(_ sender: Any) {
        if textEmail.text != nil && textPassword.text != nil {
            Auth.auth().createUser(withEmail: textEmail.text!, password: textPassword.text!) { (result, error) in
                if error != nil {
                    print("THERE WAS AN ERROR")
                }
                else{
                    self.uid = (result?.user.uid)!
                    let ref = Database.database().reference(withPath: "users").child(self.uid)
                    ref.setValue(["email": self.textEmail.text!, "password": self.textPassword.text!])
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func signinAction(_ sender: Any) {
        if textEmail.text != nil && textPassword.text != nil {
            Auth.auth().signIn(withEmail: textEmail.text!, password: textPassword.text!) { (result, error) in
                if error != nil {
                    print("THERE WAS AN ERROR")
                }
                else{
                    self.uid = (result?.user.uid)!
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let todoVC = navigation.topViewController as! TodoView
        todoVC.userID = uid
    }
}

