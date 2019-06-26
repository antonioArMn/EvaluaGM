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
    var sections = [Section]()
    
    var employees: [Employee] = [
        Employee(name: "Christian", lastName: "Montacarga Aranda", type: .forklift),
        Employee(name: "Pablo", lastName: "Corona Flores", type: .forklift),
        Employee(name: "Gerardo", lastName: "Cruz Ramírez", type: .forklift),
        Employee(name: "Fernando", lastName: "Belmont Hurtado", type: .forklift),
        Employee(name: "José Antonio", lastName: "Arellano Mendoza", type: .forklift),
        Employee(name: "José", lastName: "Herrera Ruiz", type: .forklift),
        Employee(name: "Cesar Alberto", lastName: "Bazán Caballero", type: .forklift),
        Employee(name: "Abraham", lastName: "Curiel Reyes", type: .forklift),
        Employee(name: "Andrés", lastName: "Guardado Hernández", type: .forklift),
        Employee(name: "Guillermo", lastName: "Ochoa Guerrero", type: .forklift),
        Employee(name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .forklift),
        Employee(name: "Diego", lastName: "Reyes Miranda", type: .forklift),
        Employee(name: "Rodrigo", lastName: "Flores Corona", type: .forklift),
        Employee(name: "Francisco", lastName: "Guerrero Treviño", type: .forklift),
        Employee(name: "Jesús", lastName: "Miranda Blanco", type: .forklift),
        Employee(name: "Julio Armando", lastName: "Calderón Dorantes", type: .forklift),
        Employee(name: "Aaron", lastName: "Solis Pérez", type: .forklift),
        Employee(name: "Samuel", lastName: "Pérez García", type: .forklift),
        Employee(name: "Josué", lastName: "Corona Flores", type: .forklift),
        Employee(name: "Uriel", lastName: "Antuna Cruz", type: .forklift),
        Employee(name: "Marco Antonio", lastName: "Tabares Abarca", type: .forklift),
        Employee(name: "Jorge", lastName: "Ruiz Frias", type: .forklift)
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
        
        orderEmployees(employeesArray: employees)
        
        //let groupedDictionary = Dictionary(grouping: employees, by: {String($0.name.prefix(1))})
        //let keys = groupedDictionary.keys.sorted()
        //sections = keys.map{Section(letter: $0, employees: groupedDictionary[$0]!.sorted(by: <))}

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1. Creamos la celda del mismo tipo que definimos en el storyboard: "ArticleCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        
        //2. Get the appropiate model object to display on the cell
        //let section = sections[indexPath.section]
        //let employee = section.employees[indexPath.row]
        
        //let section = sections[indexPath.section]
        let employee = sections[indexPath.section].employees[indexPath.row]
        
        //let employee = employees[indexPath.row]
        
        //3. Configuramos celda
        cell.photoImageView.image = employee.photo
        cell.nameLabel.text = "\(employee.name) \(employee.lastName)"
        cell.averageLabel.text = "\(String(format: "%.2f", employee.average)) ★" 
        
        //Reorder control button
        cell.showsReorderControl = true
        
        //4. Retornamos celda
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
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
                Employee(name: "Christian", lastName: "Montacarga Aranda", type: .forklift),
                Employee(name: "Pablo", lastName: "Corona Flores", type: .forklift),
                Employee(name: "Gerardo", lastName: "Cruz Ramírez", type: .forklift),
                Employee(name: "Fernando", lastName: "Belmont Hurtado", type: .forklift),
                Employee(name: "José Antonio", lastName: "Arellano Mendoza", type: .forklift),
                Employee(name: "José", lastName: "Herrera Ruiz", type: .forklift),
                Employee(name: "César Alberto", lastName: "Bazán Caballero", type: .forklift),
                Employee(name: "Abraham", lastName: "Curiel Reyes", type: .forklift),
                Employee(name: "Andrés", lastName: "Guardado Hernández", type: .forklift),
                Employee(name: "Guillermo", lastName: "Ochoa Guerrero", type: .forklift),
                Employee(name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .forklift),
                Employee(name: "Diego", lastName: "Reyes Miranda", type: .forklift),
                Employee(name: "Rodrigo", lastName: "Flores Corona", type: .forklift),
                Employee(name: "Francisco", lastName: "Guerrero Treviño", type: .forklift),
                Employee(name: "Jesús", lastName: "Miranda Blanco", type: .forklift),
                Employee(name: "Julio Armando", lastName: "Calderón Dorantes", type: .forklift),
                Employee(name: "Aaron", lastName: "Solis Pérez", type: .forklift),
                Employee(name: "Samuel", lastName: "Pérez García", type: .forklift),
                Employee(name: "Josué", lastName: "Corona Flores", type: .forklift),
                Employee(name: "Uriel", lastName: "Antuna Cruz", type: .forklift),
                Employee(name: "Marco Antonio", lastName: "Tabares Abarca", type: .forklift),
                Employee(name: "Jorge", lastName: "Ruiz Frias", type: .forklift)
            ]
            orderEmployees(employeesArray: employees)
        case 1:
            employees = [
                Employee(name: "Christian", lastName: "Reparto Aranda", type: .delivery),
                Employee(name: "Pablo", lastName: "Corona Flores", type: .delivery),
                Employee(name: "Gerardo", lastName: "Cruz Ramírez", type: .delivery),
                Employee(name: "Fernando", lastName: "Belmont Hurtado", type: .delivery),
                Employee(name: "José Antonio", lastName: "Arellano Mendoza", type: .delivery),
                Employee(name: "José", lastName: "Herrera Ruiz", type: .delivery),
                Employee(name: "César Alberto", lastName: "Bazán Caballero", type: .delivery),
                Employee(name: "Abraham", lastName: "Curiel Reyes", type: .delivery),
                Employee(name: "Andrés", lastName: "Guardado Hernández", type: .delivery),
                Employee(name: "Guillermo", lastName: "Ochoa Guerrero", type: .delivery),
                Employee(name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .delivery),
                Employee(name: "Diego", lastName: "Reyes Miranda", type: .delivery),
                Employee(name: "Rodrigo", lastName: "Flores Corona", type: .delivery),
                Employee(name: "Francisco", lastName: "Guerrero Treviño", type: .delivery),
                Employee(name: "Jesús", lastName: "Miranda Blanco", type: .delivery),
                Employee(name: "Julio Armando", lastName: "Calderón Dorantes", type: .delivery),
                Employee(name: "Aaron", lastName: "Solis Pérez", type: .delivery),
                Employee(name: "Samuel", lastName: "Pérez García", type: .delivery),
                Employee(name: "Josué", lastName: "Corona Flores", type: .delivery),
                Employee(name: "Uriel", lastName: "Antuna Cruz", type: .delivery),
                Employee(name: "Marco Antonio", lastName: "Tabares Abarca", type: .delivery),
                Employee(name: "Jorge", lastName: "Ruiz Frias", type: .delivery)
            ]
            orderEmployees(employeesArray: employees)
        case 2:
            employees = [
                Employee(name: "Christian", lastName: "A.Almacen Aranda", type: .warehouseAssistant),
                Employee(name: "Pablo", lastName: "Corona Flores", type: .warehouseAssistant),
                Employee(name: "Gerardo", lastName: "Cruz Ramírez", type: .warehouseAssistant),
                Employee(name: "Fernando", lastName: "Belmont Hurtado", type: .warehouseAssistant),
                Employee(name: "José Antonio", lastName: "Arellano Mendoza", type: .warehouseAssistant),
                Employee(name: "José", lastName: "Herrera Ruiz", type: .warehouseAssistant),
                Employee(name: "César Alberto", lastName: "Bazán Caballero", type: .warehouseAssistant),
                Employee(name: "Abraham", lastName: "Curiel Reyes", type: .warehouseAssistant),
                Employee(name: "Andrés", lastName: "Guardado Hernández", type: .warehouseAssistant),
                Employee(name: "Guillermo", lastName: "Ochoa Guerrero", type: .warehouseAssistant),
                Employee(name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .warehouseAssistant),
                Employee(name: "Diego", lastName: "Reyes Miranda", type: .warehouseAssistant),
                Employee(name: "Rodrigo", lastName: "Flores Corona", type: .warehouseAssistant),
                Employee(name: "Francisco", lastName: "Guerrero Treviño", type: .warehouseAssistant),
                Employee(name: "Jesús", lastName: "Miranda Blanco", type: .warehouseAssistant),
                Employee(name: "Julio Armando", lastName: "Calderón Dorantes", type: .warehouseAssistant),
                Employee(name: "Aaron", lastName: "Solis Pérez", type: .warehouseAssistant),
                Employee(name: "Samuel", lastName: "Pérez García", type: .warehouseAssistant),
                Employee(name: "Josué", lastName: "Corona Flores", type: .warehouseAssistant),
                Employee(name: "Uriel", lastName: "Antuna Cruz", type: .warehouseAssistant),
                Employee(name: "Marco Antonio", lastName: "Tabares Abarca", type: .warehouseAssistant),
                Employee(name: "Jorge", lastName: "Ruiz Frias", type: .warehouseAssistant)
            ]
            orderEmployees(employeesArray: employees)
        case 3:
            employees = [
                Employee(name: "Christian", lastName: "A.Reparto Aranda", type: .deliveryAssistant),
                Employee(name: "Pablo", lastName: "Corona Flores", type: .deliveryAssistant),
                Employee(name: "Gerardo", lastName: "Cruz Ramírez", type: .deliveryAssistant),
                Employee(name: "Fernando", lastName: "Belmont Hurtado", type: .deliveryAssistant),
                Employee(name: "José Antonio", lastName: "Arellano Mendoza", type: .deliveryAssistant),
                Employee(name: "José", lastName: "Herrera Ruiz", type: .deliveryAssistant),
                Employee(name: "César Alberto", lastName: "Bazán Caballero", type: .deliveryAssistant),
                Employee(name: "Abraham", lastName: "Curiel Reyes", type: .deliveryAssistant),
                Employee(name: "Andrés", lastName: "Guardado Hernández", type: .deliveryAssistant),
                Employee(name: "Guillermo", lastName: "Ochoa Guerrero", type: .deliveryAssistant),
                Employee(name: "Raúl Alonso", lastName: "Jiménez Mendoza", type: .deliveryAssistant),
                Employee(name: "Diego", lastName: "Reyes Miranda", type: .deliveryAssistant),
                Employee(name: "Rodrigo", lastName: "Flores Corona", type: .deliveryAssistant),
                Employee(name: "Francisco", lastName: "Guerrero Treviño", type: .deliveryAssistant),
                Employee(name: "Jesús", lastName: "Miranda Blanco", type: .deliveryAssistant),
                Employee(name: "Julio Armando", lastName: "Calderón Dorantes", type: .deliveryAssistant),
                Employee(name: "Aaron", lastName: "Solis Pérez", type: .deliveryAssistant),
                Employee(name: "Samuel", lastName: "Pérez García", type: .deliveryAssistant),
                Employee(name: "Josué", lastName: "Corona Flores", type: .deliveryAssistant),
                Employee(name: "Uriel", lastName: "Antuna Cruz", type: .deliveryAssistant),
                Employee(name: "Marco Antonio", lastName: "Tabares Abarca", type: .deliveryAssistant),
                Employee(name: "Jorge", lastName: "Ruiz Frias", type: .deliveryAssistant)
            ]
            orderEmployees(employeesArray: employees)
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
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    func orderEmployees(employeesArray: [Employee]) {
        let groupedDictionary = Dictionary(grouping: employeesArray, by: {String($0.name.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{Section(letter: $0, employees: groupedDictionary[$0]!.sorted(by: <))}
    }
    
    //let employee = employees[indexPath.row]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailVC") {
            guard let detailTableViewController = segue.destination as? DetailTableViewController, let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row else {
                print("Cant set employee")
                return
            }
            detailTableViewController.user = user
            detailTableViewController.employee = sections[section].employees[row]
        }
    }
}

//For order employees alphabetically
struct Section {
    let letter: String
    let employees: [Employee]
}
