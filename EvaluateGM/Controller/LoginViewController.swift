//
//  LoginViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/12/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var supervisorSwith: UISwitch!
    @IBOutlet weak var humanResourcesSwith: UISwitch!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    //Properties
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Uncomment to keep session and not login every time app runs
        //keepOpennedSession()
    }
    
    //Actions
    @IBAction func supervisorSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            humanResourcesSwith.isOn = false
            loginButton.isEnabled = true
        }
        if !sender.isOn && !humanResourcesSwith.isOn {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func humanResourcesSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            supervisorSwith.isOn = false
            loginButton.isEnabled = true
        }
        if !sender.isOn && !supervisorSwith.isOn {
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, emailTextField.text?.count != 0, passwordTextField.text?.count != 0 else {
            let alertController = UIAlertController(title: "Ingrese email y contraseña", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        authenticateUser(email: email, pass: password)
        //self.user = User(email: email, password: password, isSupervisor: supervisorSwith.isOn)
        //performSegue(withIdentifier: "toEmployeesTableVC", sender: nil)
    }
    
    //Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEmployeesTableVC") {
            guard let navigationController = segue.destination as? UINavigationController, let employeeTableViewController = navigationController.viewControllers.first as? EmployeeTableViewController else {
                print("Cant set login user")
                return
            }
            employeeTableViewController.user = self.user
        }
    }
    
    func authenticateUser(email: String, pass: String) {
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if let user = user {
                //Successful login
                print("Successful login, user: \(user)")
                self.user = User(email: email, password: pass, isSupervisor: self.supervisorSwith.isOn)
                self.performSegue(withIdentifier: "toEmployeesTableVC", sender: nil)
            } else {
                //Failed login
                if let error = error?.localizedDescription {
                    print("Firebase error: \(error)")
                    let alertController = UIAlertController(title: "Datos inválidos", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("Code error")
                }
            }
        }
    }
    
    func keepOpennedSession() {
        Auth.auth().addStateDidChangeListener { (auth, error) in
            if error == nil {
                print("Not logged in")
            } else {
                print("Logged in")
                self.performSegue(withIdentifier: "toEmployeesTableVC", sender: nil)
            }
        }
    }
    
    func updateUI() {
        //Programmatic Constraints
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        loginButton.layer.cornerRadius = 5.0
        
        supervisorSwith.translatesAutoresizingMaskIntoConstraints = false
        supervisorSwith.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        humanResourcesSwith.translatesAutoresizingMaskIntoConstraints = false
        humanResourcesSwith.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        //Switches
        supervisorSwith.isOn = false
        humanResourcesSwith.isOn = false
        
        //Login button
        loginButton.isEnabled = false
        loginButton.setTitleColor(.gray, for: .disabled)
        
    }

}
