//
//  LoginViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/12/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

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
            print("Enter email and password")
            let alertController = UIAlertController(title: "Ingrese email y contraseña", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        self.user = User(email: email, password: password, isSupervisor: supervisorSwith.isOn)
        performSegue(withIdentifier: "toEmployees", sender: nil)
    }
    
    //Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEmployees") {
            guard let navigationController = segue.destination as? UINavigationController, let employeesTableViewController = navigationController.viewControllers.first as? EmployeesTableViewController else {
                print("Cant set login user")
                return
            }
            employeesTableViewController.user = self.user
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
