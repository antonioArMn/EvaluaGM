//
//  EvaluateTableViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/23/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

class EvaluateTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var firstSectionView: UIView!
    @IBOutlet weak var firstSectionStackView: UIStackView!
    
    //General Outlets
    @IBOutlet weak var cultureAttatchmentLabel: UILabel!
    @IBOutlet weak var cultureAttatchmentSlider: UISlider!
    @IBOutlet weak var dpoImplementationLabel: UILabel!
    @IBOutlet weak var dpoImplementationSlider: UISlider!
    @IBOutlet weak var attitudeLabel: UILabel!
    @IBOutlet weak var attitudeSlider: UISlider!
    @IBOutlet weak var traningAdaptationLabel: UILabel!
    @IBOutlet weak var trainingAdaptationSlider: UISlider!
    @IBOutlet weak var performanceLabel: UILabel!
    @IBOutlet weak var performanceSlider: UISlider!
    
    //Specific Outlets (Forklift)
    @IBOutlet weak var forkliftSecurityLabel: UILabel!
    @IBOutlet weak var forkliftSecuritySlider: UISlider!
    @IBOutlet weak var forkliftSecurityRoutineLabel: UILabel!
    @IBOutlet weak var forkliftSecurityRoutineSlider: UISlider!
    @IBOutlet weak var forkliftChecklistLabel: UILabel!
    @IBOutlet weak var forkliftChecklistSlider: UISlider!
    @IBOutlet weak var forkliftDownloadUploadLabel: UILabel!
    @IBOutlet weak var forkliftDownloadUploadSlider: UISlider!
    @IBOutlet weak var forkliftExampleToFollowLabel: UILabel!
    @IBOutlet weak var forkliftExampleToFollowSlider: UISlider!
    
    //Specific Outlets (Delivery & DeliveryAssistant)
    @IBOutlet weak var deliverySecurityLabel: UILabel!
    @IBOutlet weak var deliverySecuritySlider: UISlider!
    @IBOutlet weak var deliveryTrainingLabel: UILabel!
    @IBOutlet weak var deliveryTrainingSlider: UISlider!
    @IBOutlet weak var deliveryKnowSegmentLabel: UILabel!
    @IBOutlet weak var deliveryKnowSegmentSlider: UISlider!
    @IBOutlet weak var deliveryKnowledgeIndicatorsLabel: UILabel!
    @IBOutlet weak var deliveryKnowledgeIndicatorsSlider: UISlider!
    @IBOutlet weak var deliveryAssistsLabel: UILabel!
    @IBOutlet weak var deliveryAssistsSlider: UISlider!
    @IBOutlet weak var deliveryTeamworkLabel: UILabel!
    @IBOutlet weak var deliveryTeamworkSlider: UISlider!
    
    //Specific Outlets (WarehouseAssistant)
    @IBOutlet weak var warehouseSecurityLabel: UILabel!
    @IBOutlet weak var warehouseSecuritySlider: UISlider!
    @IBOutlet weak var warehouseSelectionGoalLabel: UILabel!
    @IBOutlet weak var warehouseSelectionGoalSlider: UISlider!
    @IBOutlet weak var warehousePickeoGoalLabel: UILabel!
    @IBOutlet weak var warehousePickeoGoalSlider: UISlider!
    @IBOutlet weak var warehouseJobGoalsLabel: UILabel!
    @IBOutlet weak var warehouseJobGoalsSlider: UISlider!
    @IBOutlet weak var warehouseExampleToFollowLabel: UILabel!
    @IBOutlet weak var warehouseExampleToFollowSlider: UISlider!
    
    //Properties
    var employee: Employee?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let employee = employee else{
            print("Employee no received in detailVC")
            return
        }
        print("Employee received in evaluateVC: \(employee)")
        setupUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //General Actions
    @IBAction func cultureAttatchmentSliderChange(_ sender: UISlider) {
        let roundedValue = round(cultureAttatchmentSlider.value * 2) / 2
        cultureAttatchmentLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func dpoImplementationSliderChange(_ sender: UISlider) {
        let roundedValue = round(dpoImplementationSlider.value * 2) / 2
        dpoImplementationLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func attitudeSliderChange(_ sender: UISlider) {
        let roundedValue = round(attitudeSlider.value * 2) / 2
        attitudeLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func trainingAdaptation(_ sender: UISlider) {
        let roundedValue = round(trainingAdaptationSlider.value * 2) / 2
        traningAdaptationLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func performanceSliderChange(_ sender: UISlider) {
        let roundedValue = round(performanceSlider.value * 2) / 2
        performanceLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    
    //Specific Actions (Forklift)
    @IBAction func forkliftSecuritySliderChange(_ sender: UISlider) {
        let roundedValue = round(forkliftSecuritySlider.value * 2) / 2
        forkliftSecurityLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func forkliftSecurityRoutineSliderChange(_ sender: UISlider) {
        let roundedValue = round(forkliftSecurityRoutineSlider.value * 2) / 2
        forkliftSecurityRoutineLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func forkliftChecklistSliderChange(_ sender: UISlider) {
        let roundedValue = round(forkliftChecklistSlider.value * 2) / 2
        forkliftChecklistLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func forkliftDownloadUploadSliderChange(_ sender: UISlider) {
        let roundedValue = round(forkliftDownloadUploadSlider.value * 2) / 2
        forkliftDownloadUploadLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func forkliftExampleToFollowSliderChange(_ sender: UISlider) {
        let roundedValue = round(forkliftExampleToFollowSlider.value * 2) / 2
        forkliftExampleToFollowLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    
    //Specific Actions (Delivery & DeliveryAssistant)
    @IBAction func deliverySecuritySliderChange(_ sender: UISlider) {
        let roundedValue = round(deliverySecuritySlider.value * 2) / 2
        deliverySecurityLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func deliveryTrainingSliderChange(_ sender: UISlider) {
        let roundedValue = round(deliveryTrainingSlider.value * 2) / 2
        deliveryTrainingLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func deliveryKnowSegmentSliderChange(_ sender: Any) {
        let roundedValue = round(deliveryKnowSegmentSlider.value * 2) / 2
        deliveryKnowSegmentLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func deliveryKnowledgeIndicatorsSliderChange(_ sender: UISlider) {
        let roundedValue = round(deliveryKnowledgeIndicatorsSlider.value * 2) / 2
        deliveryKnowledgeIndicatorsLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func deliveryAssistsSliderChange(_ sender: UISlider) {
        let roundedValue = round(deliveryAssistsSlider.value * 2) / 2
        deliveryAssistsLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func deliveryTeamworkSliderChange(_ sender: UISlider) {
        let roundedValue = round(deliveryTeamworkSlider.value * 2) / 2
        deliveryTeamworkLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    
    //Specific Actions (WarehouseAssistant)
    @IBAction func warehouseSecuritySliderChange(_ sender: UISlider) {
        let roundedValue = round(warehouseSecuritySlider.value * 2) / 2
        warehouseSecurityLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func warehouseSelectionGoalSliderChange(_ sender: UISlider) {
        let roundedValue = round(warehouseSelectionGoalSlider.value * 2) / 2
        warehouseSelectionGoalLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func warehousePickeoGoalSliderChange(_ sender: UISlider) {
        let roundedValue = round(warehousePickeoGoalSlider.value * 2) / 2
        warehousePickeoGoalLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func warehouseJobGoalsSliderChange(_ sender: UISlider) {
        let roundedValue = round(warehouseJobGoalsSlider.value * 2) / 2
        warehouseJobGoalsLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    @IBAction func warehouseExampleToFollowSliderChange(_ sender: UISlider) {
        let roundedValue = round(warehouseExampleToFollowSlider.value * 2) / 2
        warehouseExampleToFollowLabel.text = "\(String(format: "%.1f", roundedValue))"
    }
    
    //Setup segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        employee?.cultureAttatchment = (cultureAttatchmentLabel.text! as NSString).floatValue
        employee?.dpoImplementation = (dpoImplementationLabel.text! as NSString).floatValue
        employee?.attitude = (attitudeLabel.text! as NSString).floatValue
        employee?.trainingAdaptation = (traningAdaptationLabel.text! as NSString).floatValue
        employee?.performance = (performanceLabel.text! as NSString).floatValue
        if (employee?.type == .forklift) {
            //Forklift
            employee?.specificGrades[0] = (forkliftSecurityLabel.text! as NSString).floatValue
            employee?.specificGrades[1] = (forkliftSecurityLabel.text! as NSString).floatValue
            employee?.specificGrades[2] = (forkliftSecurityLabel.text! as NSString).floatValue
            employee?.specificGrades[3] = (forkliftSecurityLabel.text! as NSString).floatValue
            employee?.specificGrades[4] = (forkliftSecurityLabel.text! as NSString).floatValue
        } else if (employee?.type == .delivery || employee?.type == .deliveryAssistant) {
            //Delivery & DeliveryAssistant
            employee?.specificGrades[0] = (deliverySecurityLabel.text! as NSString).floatValue
            employee?.specificGrades[1] = (deliveryTrainingLabel.text! as NSString).floatValue
            employee?.specificGrades[2] = (deliveryKnowSegmentLabel.text! as NSString).floatValue
            employee?.specificGrades[3] = (deliveryKnowledgeIndicatorsLabel.text! as NSString).floatValue
            employee?.specificGrades[4] = (deliveryAssistsLabel.text! as NSString).floatValue
            employee?.specificGrades[5] = (deliveryTeamworkLabel.text! as NSString).floatValue
        } else {
            //Warehouse
            employee?.specificGrades[0] = (warehouseSecurityLabel.text! as NSString).floatValue
            employee?.specificGrades[0] = (warehouseSelectionGoalLabel.text! as NSString).floatValue
            employee?.specificGrades[0] = (warehousePickeoGoalLabel.text! as NSString).floatValue
            employee?.specificGrades[0] = (warehouseJobGoalsLabel.text! as NSString).floatValue
            employee?.specificGrades[0] = (warehouseExampleToFollowLabel.text! as NSString).floatValue
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
        
        cultureAttatchmentLabel.text = "\(String(format: "%.1f", cultureAttatchmentSlider.value))"
        dpoImplementationLabel.text = "\(String(format: "%.1f", dpoImplementationSlider.value))"
        attitudeLabel.text = "\(String(format: "%.1f", attitudeSlider.value))"
        traningAdaptationLabel.text = "\(String(format: "%.1f", trainingAdaptationSlider.value))"
        performanceLabel.text = "\(String(format: "%.1f", performanceSlider.value))"
        
        forkliftSecurityLabel.text = "\(String(format: "%.1f", forkliftSecuritySlider.value))"
        forkliftSecurityRoutineLabel.text = "\(String(format: "%.1f", forkliftSecurityRoutineSlider.value))"
        forkliftChecklistLabel.text = "\(String(format: "%.1f", forkliftChecklistSlider.value))"
        forkliftDownloadUploadLabel.text = "\(String(format: "%.1f", forkliftDownloadUploadSlider.value))"
        forkliftExampleToFollowLabel.text = "\(String(format: "%.1f", forkliftExampleToFollowSlider.value))"
        
        deliverySecurityLabel.text = "\(String(format: "%.1f", deliverySecuritySlider.value))"
        deliveryTrainingLabel.text = "\(String(format: "%.1f", deliveryTrainingSlider.value))"
        deliveryKnowSegmentLabel.text = "\(String(format: "%.1f", deliveryKnowSegmentSlider.value))"
        deliveryKnowledgeIndicatorsLabel.text = "\(String(format: "%.1f", deliveryKnowledgeIndicatorsSlider.value))"
        deliveryAssistsLabel.text = "\(String(format: "%.1f", deliveryAssistsSlider.value))"
        deliveryTeamworkLabel.text = "\(String(format: "%.1f", deliveryTeamworkSlider.value))"
        
        warehouseSecurityLabel.text = "\(String(format: "%.1f", warehouseSecuritySlider.value))"
        warehouseSelectionGoalLabel.text = "\(String(format: "%.1f", warehouseSelectionGoalSlider.value))"
        warehousePickeoGoalLabel.text = "\(String(format: "%.1f", warehousePickeoGoalSlider.value))"
        warehouseJobGoalsLabel.text = "\(String(format: "%.1f", warehouseJobGoalsSlider.value))"
        warehouseExampleToFollowLabel.text = "\(String(format: "%.1f", warehouseExampleToFollowSlider.value))"
        
        guard let currentEmployee = employee else {
            return
        }
        imageView.image = currentEmployee.photo
        nameLabel.text = currentEmployee.name + " " + currentEmployee.lastName
        typeLabel.text = currentEmployee.typeString
        averageLabel.text = "\(String(format: "%.2f", currentEmployee.average)) ★"
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
    
    //TableView Configuration
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

    // MARK: - Table view data source
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
