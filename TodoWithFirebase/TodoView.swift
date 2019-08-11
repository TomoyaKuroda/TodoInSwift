//
//  TodoView.swift
//  TodoWithFirebase
//
//  Created by Tomoya Kuroda on 2019/07/26.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class TodoView: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    
    @IBOutlet weak var tableTodo: UITableView!
    
    var todos: [Todo] = []
    var userID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setWelcomeLabel()
        // Enable ViewController to configure tableViewCell
        tableTodo.delegate = self
        tableTodo.dataSource = self
        // height of each Todo
        tableTodo.rowHeight = 80
        
        
        loadTodos()
        // Do any additional setup after loading the view.
    }
    // Display Welcome message
    func setWelcomeLabel(){
        let userRef = Database.database().reference(withPath: "users").child(userID!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value!["email"] as? String
            self.welcomeLabel.text = "Hello " + email! + "!"
        }
    }
    // Logout
    @IBAction func logoutAction(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Get data from firabase database
    func loadTodos(){
        let ref = Database.database().reference(withPath: "users").child(userID!).child("todos")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot]{
                let todoName = child.key
                let todoRef = ref.child(todoName)
                todoRef.observeSingleEvent(of: .value, with: { (todoSnapshot) in
                    let value = todoSnapshot.value as? NSDictionary
                    let isChecked = value!["isChecked"] as? Bool
                    self.todos.append(Todo(isChecked: isChecked!, todoName: todoName))
                    self.tableTodo.reloadData()
                })
            }
        }
    }
    // Configure number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Configure the number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    // Update checmmark icon according to the value "isChecked"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        cell.todoLabel.text = todos[indexPath.row].todoName
        if todos[indexPath.row].isChecked {
            cell.checkmarkImage.image = UIImage(named: "checkmark.png")
        } else {
            cell.checkmarkImage.image = nil
        }
        return cell
    }
    // Update isChecked whenever the task is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let ref = Database.database().reference(withPath: "users").child(userID!).child("todos").child(todos[indexPath.row].todoName)
        
        if todos[indexPath.row].isChecked {
            todos[indexPath.row].isChecked = false
          
            ref.updateChildValues(["isChecked": false])
        }
        else{
            todos[indexPath.row].isChecked = true
            
            ref.updateChildValues(["isChecked": true])
        }
        tableView.reloadData()
    }
    
    
    // Delete todo
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ref = Database.database().reference(withPath: "users").child(userID!).child("todos").child(todos[indexPath.row].todoName)
            ref.removeValue()
            todos.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    // Pass userID to addViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is addViewController
        {
            let vc = segue.destination as? addViewController
            vc?.userID=userID
            
        }
        
    }
    
    
    
}
