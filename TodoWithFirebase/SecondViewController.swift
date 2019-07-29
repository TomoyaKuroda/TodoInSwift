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
        
        if textEmail.text == "" || textPassword.text == "" {
        let alertController = UIAlertController(title: "Error", message: "Please enter both your email and password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: textEmail.text!, password: textPassword.text!) { (result, error) in
                if error == nil {
                    self.uid = (result?.user.uid)!
                    let ref = Database.database().reference(withPath: "users").child(self.uid)
                    ref.setValue(["email": self.textEmail.text!, "password": self.textPassword.text!])
//                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation = segue.destination as! UINavigationController
        let todoVC = navigation.topViewController as! TodoView
        todoVC.userID = uid
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
