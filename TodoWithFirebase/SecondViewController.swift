//
//  SecondViewController.swift
//  TodoWithFirebase
//
//  Created by Dongjun Yu on 2019-07-29.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SecondViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    var uid: String = ""
    var user = User(uid: "", email: "", password: "")
    
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
    
    
    @IBAction func registerAction(_ sender: Any){
        self.user.email = textEmail.text!
        self.user.password = textPassword.text!
        if (self.user.email == "" || self.user.password == "") {
        let alertController = UIAlertController(title: "Oops!", message: "Please enter both your email and password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: self.user.email, password: self.user.password) { (result, error) in
                if error == nil {
                    self.user.uid = (result?.user.uid)!
                    let ref = Database.database().reference(withPath: "users").child(self.user.uid)
                    ref.setValue(["email": self.user.email, "password": self.user.password])
//                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                } else {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
