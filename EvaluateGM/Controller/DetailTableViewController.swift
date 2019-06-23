//
//  DetailTableViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/20/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    //Properties
    var employee: Employee?
    var imagePicker: ImagePicker!
    let hideMontacarga: Bool = false
    let hideReparto: Bool = true
    let hideAAlmacen: Bool = true
    let hideAReparto: Bool = true
    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var firstSectionView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var firstSectionStackView: UIStackView!
    @IBOutlet weak var cultureAttatchment: UILabel!
    @IBOutlet weak var dpoImplementation: UILabel!
    @IBOutlet weak var attitude: UILabel!
    @IBOutlet weak var trainingAdaptation: UILabel!
    @IBOutlet weak var performance: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let employee = employee else{
            print("Emplyee no received in detailVC")
            return
        }
        print("Employee received in detalVC: \(employee)")
        setupUI()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Actions
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        print("Camera button tapped")
        self.imagePicker.present(from: sender)
    }
    
    //Methods
    func setupUI() {
        tableView.allowsSelection = false
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: ((firstSectionView.frame.height - firstSectionStackView.frame.height) / 2) + imageView.frame.height / 2).isActive = true
    
        imageView.layer.borderWidth = 1.0
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
        
        guard let currentEmployee = employee else {
            return
        }
        imageView.image = currentEmployee.photo
        nameLabel.text = currentEmployee.name + " " + currentEmployee.lastName
        typeLabel.text = currentEmployee.typeString
        averageLabel.text = "\(String(format: "%.2f", currentEmployee.average)) ★"
        cultureAttatchment.text = "\(String(format: "%.2f", currentEmployee.cultureAttatchment))"
        dpoImplementation.text = "\(String(format: "%.2f", currentEmployee.dpoImplementation))"
        attitude.text = "\(String(format: "%.2f", currentEmployee.attitude))"
        trainingAdaptation.text = "\(String(format: "%.2f", currentEmployee.trainingAdaptation))"
        performance.text = "\(String(format: "%.2f", currentEmployee.performance))"
    }
    
    func shouldHideSection(section: Int) -> Bool {
        switch section {
        case 2:
            if(hideMontacarga) {
                return true
            } else {
                return false
            }
        case 3:
            if(hideReparto) {
                return true
            } else {
                return false
            }
        case 4:
            if(hideAAlmacen) {
                return true
            } else {
                return false
            }
        case 5:
            if(hideAReparto) {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }

    // MARK: - Table view data source

    //Hide headers
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return shouldHideSection(section: section) ? 0.1 : super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    //Hide footers
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return shouldHideSection(section: section) ? 0.1 : super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    //Hide rows in hidden sections
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return shouldHideSection(section: indexPath.section) ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    //Hide header text
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if(shouldHideSection(section: section)) {
            let headerView = view as! UITableViewHeaderFooterView
            headerView.textLabel!.textColor = UIColor.clear
        }
    }
    
    //Hide footer text
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if(shouldHideSection(section: section)) {
            let footerView = view as! UITableViewHeaderFooterView
            footerView.textLabel!.textColor = UIColor.clear
        }
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailTableViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let imageSelected = image else {
            return
        }
        employee?.photo = imageSelected
        setupUI()
        //self.imageView.image = image
    }
}
