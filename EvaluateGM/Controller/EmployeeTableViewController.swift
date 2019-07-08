//
//  EmployeeTableViewController.swift
//  EvaluateGM
//
//  Created by José Antonio Arellano Mendoza on 6/21/19.
//  Copyright © 2019 José Antonio Arellano Mendoza. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EmployeeTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Properties
    //var user: User? //We dont need to receive user from loginVC
    var currentUser: User?
    var sections = [Section]()
    var employee = Employee(name: "Name", lastName: "lastName", type: .forklift)
    var filteredEmployees = [Employee]() //For search bar
    
    var ref: DatabaseReference!
    
//    var forkliftEmployees: [Employee] = []
//    var deliveryEmployees: [Employee] = []
//    var warehouseAssistantEmployees: [Employee] = []
//    var deliveryAssistantEmployees: [Employee] = []
    
    var forkliftEmployees: [Employee] = [
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

    var deliveryEmployees: [Employee] = [
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

    var warehouseAssistantEmployees: [Employee] = [
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

    var deliveryAssistantEmployees: [Employee] = [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        ref = Database.database().reference()
        readCurrentUser()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //guard let user = user else{
        //    print("User no received in EmployeeTableVC")
        //    return
        //}
        //print("User received in EmployeeTableVC: \(user)")
        
        orderEmployees(employeesArray: forkliftEmployees)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            orderEmployees(employeesArray: forkliftEmployees)
        case 1:
            orderEmployees(employeesArray: deliveryEmployees)
        case 2:
            orderEmployees(employeesArray: warehouseAssistantEmployees)
        case 3:
            orderEmployees(employeesArray: deliveryAssistantEmployees)
        default:
            print("Other case")
        }
        tableView.reloadData()
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
        let employee = sections[indexPath.section].employees[indexPath.row]
        
        //3. Configuramos celda
        cell.photoImageView.image = employee.photo
        cell.nameLabel.text = "\(employee.name) \(employee.lastName)"
        if employee.hasBeenEvaluated {
            cell.averageLabel.text = "\(String(format: "%.2f", employee.getGeneralAverage())) ★"
            if employee.averageIndicator {
                cell.averageIndicator.textColor = UIColor(red:0.00, green:0.56, blue:0.00, alpha:1.0)
                cell.averageIndicator.text = "↑"
            } else {
                cell.averageIndicator.textColor = .red
                cell.averageIndicator.text = "↓"
            }

        } else {
            cell.averageLabel.text = "Sin evaluaciones"
            cell.averageIndicator.text = ""
        }
        
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
        return 64.0
    }
    
    //Actions
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            orderEmployees(employeesArray: forkliftEmployees)
        case 1:
            orderEmployees(employeesArray: deliveryEmployees)
        case 2:
            orderEmployees(employeesArray: warehouseAssistantEmployees)
        case 3:
            orderEmployees(employeesArray: deliveryAssistantEmployees)
        default:
            print("Other case")
        }
        tableView.reloadData()
    }
    
    @IBAction func addEmployeeButtonTapped(_ sender: UIBarButtonItem) {
        guard let user = currentUser else{
            return
        }
        if user.isSupervisor {
            let alertController = UIAlertController(title: "Acceso denegado", message: "Acción sólo válida para usuarios de recursos humanos.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toAddEmployeeVC", sender: nil)
        }
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Cierre de sesión", message: "¿Está seguro que desea cerrar sesión?", preferredStyle: .actionSheet)
        let acceptAction = UIAlertAction(title: "Si", style: .destructive) { (_) in
            do {
                try Auth.auth().signOut()
                print("Successful logout")
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "toLoginVC", sender: nil)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Functions
    func setupNavigationBar() {
        //Add search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Buscar"
        searchController.searchBar.setValue("Cancelar", forKey: "_cancelButtonText")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationController?.setToolbarHidden(false, animated: true)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func orderEmployees(employeesArray: [Employee]) {
        let groupedDictionary = Dictionary(grouping: employeesArray, by: {String($0.name.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{Section(letter: $0, employees: groupedDictionary[$0]!.sorted(by: <))}
    }
    
    func readCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let lastName = value?["lastName"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            let password = value?["password"] as? String ?? ""
            let isSupervisor = value?["isSupervisor"] as? Bool ?? false
            let userId = value?["userId"] as? String ?? ""
            self.currentUser = User(name: name, lastName: lastName, email: email, password: password, isSupervisor: isSupervisor)
            guard var currentUser = self.currentUser else {
                return
            }
            currentUser.userId = userId
            print("Current user: \(currentUser)")
        }
    }
    
    //Setup segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetailVC") {
            guard let detailTableViewController = segue.destination as? DetailTableViewController, let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row else {
                print("Cant set employee")
                return
            }
            detailTableViewController.user = currentUser //user
            detailTableViewController.employee = sections[section].employees[row]
            detailTableViewController.delegate = self
        }
    }
    
    //Unwind segues
    @IBAction func saveEmployee(unwindSegue: UIStoryboardSegue) {
        guard let addEmployeeViewController = unwindSegue.source as? AddEmployeeViewController else {
            print("Cant receive new employee")
            return
        }
        employee = addEmployeeViewController.employee
        switch employee.type {
        case .forklift:
            forkliftEmployees.append(employee)
        case .delivery:
            deliveryEmployees.append(employee)
        case .warehouseAssistant:
            warehouseAssistantEmployees.append(employee)
        case .deliveryAssistant:
            deliveryAssistantEmployees.append(employee)
        }
    }
    @IBAction func cancelNewEmployee(unwindSegue: UIStoryboardSegue) {

    }
}

extension EmployeeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //TODO
    }
}

extension EmployeeTableViewController: DetailTableViewControllerDelegate {
    func update(_ employee: Employee) {
        print("Empleado actualizado: \(employee)")
        
        switch employee.type {
        case .forklift:
            for (index, oldEmployee) in forkliftEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    forkliftEmployees[index] = employee
                }
            }
        case .delivery:
            for (index, oldEmployee) in deliveryEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    deliveryEmployees[index] = employee
                }
            }
        case .warehouseAssistant:
            for (index, oldEmployee) in warehouseAssistantEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    warehouseAssistantEmployees[index] = employee
                }
            }
        case .deliveryAssistant:
            for (index, oldEmployee) in deliveryAssistantEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    deliveryAssistantEmployees[index] = employee
                }
            }
        }
    }
}

//For order employees alphabetically
struct Section {
    let letter: String
    var employees: [Employee]
}
