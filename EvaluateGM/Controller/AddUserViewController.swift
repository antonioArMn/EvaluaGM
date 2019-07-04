//
//  AddUserViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 7/4/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reaffirmPasswordTextField: UITextField!
    @IBOutlet weak var supervisorSwitch: UISwitch!
    @IBOutlet weak var humanResourcesSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //Actions
    @IBAction func supervisorSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            humanResourcesSwitch.isOn = false
        } else {
            humanResourcesSwitch.isOn = true
        }
    }
    @IBAction func humanResourcesSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            supervisorSwitch.isOn = false
        } else {
            supervisorSwitch.isOn = true
        }
    }
    
    func setupUI() {
        imageView.alpha = 0.05
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        lastNameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        reaffirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        reaffirmPasswordTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        reaffirmPasswordTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        supervisorSwitch.translatesAutoresizingMaskIntoConstraints = false
        supervisorSwitch.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        humanResourcesSwitch.translatesAutoresizingMaskIntoConstraints = false
        humanResourcesSwitch.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        
        supervisorSwitch.isOn = true
        humanResourcesSwitch.isOn = false
    }
}
