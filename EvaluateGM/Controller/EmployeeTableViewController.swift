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
        Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Montacarga Aranda", average: 9.35),
        Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", average: 7.38),
        Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", average: 8.28),
        Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", average: 9.83),
        Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", average: 6.92),
        Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", average: 6.88),
        Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", average: 9.22),
        Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", average: 7.09),
        Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", average: 6.12),
        Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", average: 9.36),
        Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", average: 9.36),
        Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", average: 6.90),
        Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", average: 9.68),
        Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", average: 7.30),
        Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", average: 8.40),
        Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes de Mendoza", average: 6.55),
        Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", average: 8.09),
        Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", average: 9.66),
        Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", average: 8.75),
        Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", average: 8.35),
        Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", average: 6.47),
        Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", average: 9.99)
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
        cell.averageLabel.text = "\(employee.average) ★"
        
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
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Montacarga Aranda", average: 9.35),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", average: 7.38),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", average: 8.28),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", average: 9.83),
                Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", average: 6.92),
                Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", average: 6.88),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", average: 9.22),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", average: 7.09),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", average: 6.12),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", average: 6.90),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", average: 9.68),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", average: 7.30),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", average: 8.40),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes de Mendoza", average: 6.55),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", average: 8.09),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", average: 9.66),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", average: 8.75),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", average: 8.35),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", average: 6.47),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", average: 9.99)
            ]
        case 1:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Reparto Aranda", average: 9.35),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", average: 7.38),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", average: 8.28),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", average: 9.83),
                Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", average: 6.92),
                Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", average: 6.88),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", average: 9.22),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", average: 7.09),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", average: 6.12),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", average: 6.90),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", average: 9.68),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", average: 7.30),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", average: 8.40),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes de Mendoza", average: 6.55),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", average: 8.09),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", average: 9.66),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", average: 8.75),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", average: 8.35),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", average: 6.47),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", average: 9.99)
            ]
        case 2:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "A.Almacen Aranda", average: 9.35),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", average: 7.38),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", average: 8.28),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", average: 9.83),
                Employee(photo: UIImage(named: "User")!, name: "José Antonio", lastName: "Arellano Mendoza", average: 6.92),
                Employee(photo: UIImage(named: "me")!, name: "José", lastName: "Herrera Ruiz", average: 6.88),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", average: 9.22),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", average: 7.09),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", average: 6.12),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", average: 6.90),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", average: 9.68),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", average: 7.30),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", average: 8.40),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes de Mendoza", average: 6.55),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", average: 8.09),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", average: 9.66),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", average: 8.75),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", average: 8.35),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", average: 6.47),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", average: 9.99)
            ]
        case 3:
            employees = [
                Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "A.Reparto Aranda", average: 9.35),
                Employee(photo: UIImage(named: "User")!, name: "Pablo", lastName: "Corona Flores", average: 7.38),
                Employee(photo: UIImage(named: "User")!, name: "Gerardo", lastName: "Cruz Ramírez", average: 8.28),
                Employee(photo: UIImage(named: "User")!, name: "Fernando", lastName: "Belmont Hurtado", average: 9.83),
                Employee(photo: UIImage(named: "me")!, name: "José Antonio", lastName: "Arellano Mendoza", average: 6.92),
                Employee(photo: UIImage(named: "User")!, name: "José", lastName: "Herrera Ruiz", average: 6.88),
                Employee(photo: UIImage(named: "User")!, name: "César Alberto", lastName: "Bazán Caballero", average: 9.22),
                Employee(photo: UIImage(named: "User")!, name: "Abraham", lastName: "Curiel Reyes", average: 7.09),
                Employee(photo: UIImage(named: "User")!, name: "Andrés", lastName: "Guardado Hernández", average: 6.12),
                Employee(photo: UIImage(named: "User")!, name: "Guillermo", lastName: "Ochoa Guerrero", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Raúl Alonso", lastName: "Jiménez Mendoza", average: 9.36),
                Employee(photo: UIImage(named: "User")!, name: "Diego", lastName: "Reyes Miranda", average: 6.90),
                Employee(photo: UIImage(named: "User")!, name: "Rodrigo", lastName: "Flores Corona", average: 9.68),
                Employee(photo: UIImage(named: "User")!, name: "Francisco", lastName: "Guerrero Treviño", average: 7.30),
                Employee(photo: UIImage(named: "User")!, name: "Jesús", lastName: "Miranda Blanco", average: 8.40),
                Employee(photo: UIImage(named: "User")!, name: "Julio Armando", lastName: "Calderón Dorantes de Mendoza", average: 6.55),
                Employee(photo: UIImage(named: "User")!, name: "Aaron", lastName: "Solis Pérez", average: 8.09),
                Employee(photo: UIImage(named: "User")!, name: "Samuel", lastName: "Pérez García", average: 9.66),
                Employee(photo: UIImage(named: "User")!, name: "Josué", lastName: "Corona Flores", average: 8.75),
                Employee(photo: UIImage(named: "User")!, name: "Uriel", lastName: "Antuna Cruz", average: 8.35),
                Employee(photo: UIImage(named: "User")!, name: "Marco Antonio", lastName: "Tabares Abarca", average: 6.47),
                Employee(photo: UIImage(named: "User")!, name: "Jorge", lastName: "Ruiz Frias", average: 9.99)
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
