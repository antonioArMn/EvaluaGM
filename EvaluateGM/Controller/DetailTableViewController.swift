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
    
    //General Outlets
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
    
    //Specific Outlets (Forklift)
    @IBOutlet weak var forkliftSecurity: UILabel!
    @IBOutlet weak var forkliftSecurityRoutine: UILabel!
    @IBOutlet weak var forkliftChecklist: UILabel!
    @IBOutlet weak var forkliftDownloadUpload: UILabel!
    @IBOutlet weak var forkliftExampleToFollow: UILabel!
    
    //Specific Outlets (Delivery & DeliveryAssistant)
    @IBOutlet weak var deliverySecurity: UILabel!
    @IBOutlet weak var deliveryTraining: UILabel!
    @IBOutlet weak var deliveryKnowSegment: UILabel!
    @IBOutlet weak var deliveryKnowledgeIndicators: UILabel!
    @IBOutlet weak var deliveryAssists: UILabel!
    @IBOutlet weak var deliveryTeamwork: UILabel!
    
    //Specific Outlets (WarehouseAssistant)
    @IBOutlet weak var warehouseSecurity: UILabel!
    @IBOutlet weak var warehouseSelectionGoal: UILabel!
    @IBOutlet weak var warehousePickeoGoal: UILabel!
    @IBOutlet weak var warehouseJobGoals: UILabel!
    @IBOutlet weak var warehouseExampleToFollow: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let employee = employee else{
            print("Employee no received in detailVC")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setupUI()
    }
    
    //Actions
    @IBAction func save(unwindSegue: UIStoryboardSegue) {
        guard let evaluateViewController = unwindSegue.source as? EvaluateTableViewController else {
            print("Cant receive evaluated employee")
            return
        }
        employee = evaluateViewController.employee
    }
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
    }
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        print("Camera button tapped")
        self.imagePicker.present(from: sender)
    }
    @IBAction func evaluateButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toEvaluateVC", sender: nil)
    }
    
    //Setup Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEvaluateVC") {
            guard let navigationController = segue.destination as? UINavigationController, let evaluateTableViewController = navigationController.viewControllers.first as? EvaluateTableViewController else {
                print("Cant set employee")
                return
            }
            evaluateTableViewController.employee = employee
        }
    }
    
    //Methods
    func setupUI() {
        tableView.allowsSelection = false
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.heightAnchor.constraint(equalToConstant: ((firstSectionView.frame.height - firstSectionStackView.frame.height) / 2) + imageView.frame.height / 2).isActive = true
    
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
        switch currentEmployee.type {
        case .forklift:
            forkliftSecurity.text = "\(String(format: "%.2f", currentEmployee.specificGrades[0]))"
            forkliftSecurityRoutine.text = "\(String(format: "%.2f", currentEmployee.specificGrades[1]))"
            forkliftChecklist.text = "\(String(format: "%.2f", currentEmployee.specificGrades[2]))"
            forkliftDownloadUpload.text = "\(String(format: "%.2f", currentEmployee.specificGrades[3]))"
            forkliftExampleToFollow.text = "\(String(format: "%.2f", currentEmployee.specificGrades[4]))"
            
        case .delivery, .deliveryAssistant:
            deliverySecurity.text = "\(String(format: "%.2f", currentEmployee.specificGrades[0]))"
            deliveryTraining.text = "\(String(format: "%.2f", currentEmployee.specificGrades[1]))"
            deliveryKnowSegment.text = "\(String(format: "%.2f", currentEmployee.specificGrades[2]))"
            deliveryKnowledgeIndicators.text = "\(String(format: "%.2f", currentEmployee.specificGrades[3]))"
            deliveryAssists.text = "\(String(format: "%.2f", currentEmployee.specificGrades[4]))"
            deliveryTeamwork.text = "\(String(format: "%.2f", currentEmployee.specificGrades[5]))"
        case .warehouseAssistant:
            warehouseSecurity.text = "\(String(format: "%.2f", currentEmployee.specificGrades[0]))"
            warehouseSelectionGoal.text = "\(String(format: "%.2f", currentEmployee.specificGrades[1]))"
            warehousePickeoGoal.text = "\(String(format: "%.2f", currentEmployee.specificGrades[2]))"
            warehouseJobGoals.text = "\(String(format: "%.2f", currentEmployee.specificGrades[3]))"
            warehouseExampleToFollow.text = "\(String(format: "%.2f", currentEmployee.specificGrades[4]))"
        }
    }
    
    func shouldHideSection(section: Int) -> Bool {
        switch section {
        case 2:
            if(employee?.type != Type.forklift) {
                return true
            } else {
                return false
            }
        case 3:
            if(employee?.type != Type.delivery && employee?.type != Type.deliveryAssistant) {
                return true
            } else {
                return false
            }
        case 4:
            if(employee?.type != Type.warehouseAssistant) {
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
