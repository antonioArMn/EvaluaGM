//
//  EmployeesTableViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/19/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit

class EmployeesTableViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var employeesTableView: UITableView!
    
    //Properties
    var user: User?
    var employees: [Employee] = [
        Employee(photo: UIImage(named: "User")!, name: "Christian", lastName: "Alonso Aranda", average: 9.35),
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
        guard let user = user else{
            print("User no received in employees")
            return
        }
        print("User received in employees: \(user)")
        segmentedControl.selectedSegmentIndex = 0
        
        //Constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        employeesTableView.translatesAutoresizingMaskIntoConstraints = false
        employeesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        employeesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        employeesTableView.reloadData()
        employeesTableView.dataSource = self
        employeesTableView.delegate = self
    }
    
    //Actions
    @IBAction func segmentedControlChange(_ sender: Any) {
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
        employeesTableView.reloadData()
    }
    
    //Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailViewController") {
            guard let detalTableViewController = segue.destination as? DetailTableViewController, let index = employeesTableView.indexPathForSelectedRow?.row else {
                print("Cant set employee")
                return
            }
            detalTableViewController.employee = employees[index]
        }
    }
    
    func setupNavigationBar() {
        //Add search controller
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    //Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. Creamos la celda del mismo tipo que definimos en el storyboard: "ArticleCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeTableViewCell
        
        //2. Get the appropiate model object to display on the cell
        let employee = employees[indexPath.row]
        
        //3. Configuramos celda
        cell.photoImageView.image = employee.photo
        cell.nameLabel.text = employee.name + " " + employee.lastName
        cell.averageLabel.text = "\(employee.average) ★"
        
        //Reorder control button
        cell.showsReorderControl = true
        
        //4. Retornamos celda
        print(cell)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
}
