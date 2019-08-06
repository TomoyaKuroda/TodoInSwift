//
//  addViewController.swift
//  TodoWithFirebase
//
//  Created by Yang Su on 2019-08-06.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class addViewController: UIViewController {

    @IBOutlet weak var toDoTF: UITextField!
    var todos: [Todo] = []
    var userID: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addBtn(_ sender: Any) {
        let todoText=toDoTF.text!
        if todoText==""{
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Oops", message: "Please enter a todo name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            self.todos.append(Todo(isChecked: false, todoName: todoText))
            let ref = Database.database().reference(withPath: "users").child(self.userID!).child("todos")
            ref.child(todoText).setValue(["isChecked": false])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TodoView
        {
            let vc = segue.destination as? TodoView
            vc?.userID=userID
            
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
