//
//  AddEmployeeViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/28/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

class AddEmployeeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Properties
    let pickerData = ["Montacarga", "Reparto", "Ayudante de almacén", "Ayudante de reparto"]
    
    //Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Methods
    func setupUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -95).isActive = true
        //backgroundView.heightAnchor.constraint(equalToConstant: imageView.frame.height / 2).isActive = true
        
        imageView.layer.borderWidth = 6.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10).isActive = true
        cameraButton.layer.borderWidth = 1.0
        cameraButton.layer.masksToBounds = false
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.cornerRadius = cameraButton.frame.size.height / 2
        cameraButton.clipsToBounds = true
    }
}
