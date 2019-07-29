//
//  ThirdViewController.swift
//  TodoWithFirebase
//
//  Created by Dongjun Yu on 2019-07-29.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ThirdViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    
    var uid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textEmail.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textEmail.text = ""
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        if self.textEmail.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.textEmail.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.textEmail.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let navigation = segue.destination as! UINavigationController
//        let todoVC = navigation.topViewController as! TodoView
//        todoVC.userID = uid
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
