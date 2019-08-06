//
//  TodoView.swift
//  TodoWithFirebase
//
//  Created by user user on 2019/07/26.
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
        tableTodo.delegate = self
        tableTodo.dataSource = self
        tableTodo.rowHeight = 80
        
        
        loadTodos()
        // Do any additional setup after loading the view.
    }
    
    func setWelcomeLabel(){
        let userRef = Database.database().reference(withPath: "users").child(userID!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value!["email"] as? String
            self.welcomeLabel.text = "Hello " + email! + "!"
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addTodo(_ sender: Any) {
        let todoAlert = UIAlertController(title: "New Todo", message: "Add a todo", preferredStyle: .alert)
        todoAlert.addTextField()
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let todoText = todoAlert.textFields![0].text
            self.todos.append(Todo(isChecked: false, todoName: todoText!))
            let ref = Database.database().reference(withPath: "users").child(self.userID!).child("todos")
            ref.child(todoText!).setValue(["isChecked": false])
            self.tableTodo.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        todoAlert.addAction(addTodoAction)
        todoAlert.addAction(cancelAction)
        
        present(todoAlert, animated: true, completion: nil)
    }
    
    
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    // Update checmmark icon
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is addViewController
        {
            let vc = segue.destination as? addViewController
            vc?.userID=userID
            
        }
        
    }
    
    
    
}
