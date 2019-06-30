//
//  DetailTableViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/20/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

protocol DetailTableViewControllerDelegate: AnyObject {
    func update(_ employee: Employee)
}

class DetailTableViewController: UITableViewController {
    
    //Properties
    var user: User?
    var employee: Employee?
    var imagePicker: ImagePicker!
    weak var delegate: DetailTableViewControllerDelegate?
    
    //General Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var averageIndicator: UILabel!
    @IBOutlet weak var firstSectionView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var firstSectionStackView: UIStackView!
    @IBOutlet weak var cultureAttatchment: UILabel!
    @IBOutlet weak var cultureAttatchmentIndicator: UILabel!
    @IBOutlet weak var dpoImplementation: UILabel!
    @IBOutlet weak var dpoImplementationIndicator: UILabel!
    @IBOutlet weak var attitude: UILabel!
    @IBOutlet weak var attitudeIndicator: UILabel!
    @IBOutlet weak var trainingAdaptation: UILabel!
    @IBOutlet weak var trainingAdaptationIndicator: UILabel!
    @IBOutlet weak var performance: UILabel!
    @IBOutlet weak var performanceIndicator: UILabel!
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
        if let employee = employee {
            delegate?.update(employee)
        }
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
            guard let user = user  else {
                return
            }
            if(user.isSupervisor) {
                guard let navigationController = segue.destination as? UINavigationController, let evaluateTableViewController = navigationController.viewControllers.first as? EvaluateTableViewController else {
                    print("Cant set employee")
                    return
                }
                evaluateTableViewController.employee = employee
            } else {
                let alertController = UIAlertController(title: "Acción sólo válida para usuarios supervisores.", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
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
        averageLabel.text = "\(String(format: "%.2f", currentEmployee.getGeneralAverage())) ★"
        setIndicator(employee: currentEmployee, label: averageIndicator)
        cultureAttatchment.text = "\(String(format: "%.2f", currentEmployee.getCultureAttatchmentAverage()))"
        setIndicator(employee: currentEmployee, label: cultureAttatchmentIndicator)
        dpoImplementation.text = "\(String(format: "%.2f", currentEmployee.getDpoImplementationAverage()))"
        setIndicator(employee: currentEmployee, label: dpoImplementationIndicator)
        attitude.text = "\(String(format: "%.2f", currentEmployee.getAttitudeAverage()))"
        setIndicator(employee: currentEmployee, label: attitudeIndicator)
        trainingAdaptation.text = "\(String(format: "%.2f", currentEmployee.getTrainingAdaptationAverage()))"
        setIndicator(employee: currentEmployee, label: trainingAdaptationIndicator)
        performance.text = "\(String(format: "%.2f", currentEmployee.getPerformanceAverage()))"
        setIndicator(employee: currentEmployee, label: performanceIndicator)
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
    
    func setIndicator(employee: Employee, label: UILabel) {
        switch label {
        case averageIndicator:
            if employee.averageIndicator {
                label.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                label.text = "↑"
            } else {
                label.textColor = .red
                label.text = "↓"
            }
        case cultureAttatchmentIndicator:
            if employee.cultureAttatchmentIndicator {
                label.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                label.text = "↑"
            } else {
                label.textColor = .red
                label.text = "↓"
            }
        case dpoImplementationIndicator:
            if employee.dpoImplementationIndicator {
                label.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                label.text = "↑"
            } else {
                label.textColor = .red
                label.text = "↓"
            }
        case attitudeIndicator:
            if employee.attitudeIndicator {
                label.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                label.text = "↑"
            } else {
                label.textColor = .red
                label.text = "↓"
            }
        case trainingAdaptationIndicator:
            if employee.trainingAdaptationIndicator {
                label.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                label.text = "↑"
            } else {
                label.textColor = .red
                label.text = "↓"
            }
        case performanceIndicator:
            if employee.performanceIndicator {
                label.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                label.text = "↑"
            } else {
                label.textColor = .red
                label.text = "↓"
            }
        default:
            print("Other case")
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
}

extension DetailTableViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let imageSelected = image else {
            return
        }
        employee?.photo = imageSelected
        setupUI()
        if let employee = employee {
            delegate?.update(employee)
        }
    }
}
