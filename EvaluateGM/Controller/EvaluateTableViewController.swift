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
    
    //Actions
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
    
    //Setup segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        employee?.cultureAttatchment = (cultureAttatchmentLabel.text! as NSString).floatValue
        employee?.dpoImplementation = (dpoImplementationLabel.text! as NSString).floatValue
        employee?.attitude = (attitudeLabel.text! as NSString).floatValue
        employee?.trainingAdaptation = (traningAdaptationLabel.text! as NSString).floatValue
        employee?.performance = (performanceLabel.text! as NSString).floatValue
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
        
        guard let currentEmployee = employee else {
            return
        }
        imageView.image = currentEmployee.photo
        nameLabel.text = currentEmployee.name + " " + currentEmployee.lastName
        typeLabel.text = currentEmployee.typeString
        averageLabel.text = "\(String(format: "%.2f", currentEmployee.average)) ★"
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
