//
//  EmployeeTableViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/21/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

class EmployeeTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Properties
    var user: User?
    var employees: [Employee] = [
        Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Montacarga Aranda", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Alejandro", lastName: "Ortiz Romero", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", type: .forklift),
        Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", type: .forklift),
        Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", type: .forklift)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let user = user else{
            print("User no received in EmployeeTableVC")
            return
        }
        print("User received in EmployeeTableVC: \(user)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1. Creamos la celda del mismo tipo que definimos en el storyboard: "ArticleCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        
        //2. Get the appropiate model object to display on the cell
        let employee = employees[indexPath.row]
        
        //3. Configuramos celda
        cell.photoImageView.image = employee.photo
        cell.nameLabel.text = employee.name + " " + employee.lastName
        cell.averageLabel.text = "\(String(format: "%.2f", employee.average)) ★" 
        
        //Reorder control button
        cell.showsReorderControl = true
        
        //4. Retornamos celda
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }

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
    
    //Actions
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Montacarga Aranda", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", type: .forklift),
                Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", type: .forklift),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", type: .forklift)
            ]
        case 1:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Reparto Aranda", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", type: .delivery),
                Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", type: .delivery),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", type: .delivery)
            ]
        case 2:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "A.Almacen Aranda", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "José Antonio", lastName: "Arellano Mendoza", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "me")!, name: "José", lastName: "Herrera Ruiz", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", type: .warehouseAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", type: .warehouseAssistant)
            ]
        case 3:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "A.Reparto Aranda", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", type: .deliveryAssistant),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", type: .deliveryAssistant)
            ]
        default:
            print("Other case")
        }
        tableView.reloadData()
    }
    
    //Functions
    func setupNavigationBar() {
        //Add search controller
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailVC") {
            guard let detailTableViewController = segue.destination as? DetailTableViewController, let index = tableView.indexPathForSelectedRow?.row else {
                print("Cant set employee")
                return
            }
            detailTableViewController.employee = employees[index]
        }
    }
}
