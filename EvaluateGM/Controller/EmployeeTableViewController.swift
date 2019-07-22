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
import FirebaseStorage

class EmployeeTableViewController: UITableViewController {
    
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Properties
    //var user: User? //We dont need to receive user from loginVC
    var currentUser: User?
    var sections = [Section]()
    var employee = Employee(name: "Name", lastName: "lastName", type: .forklift) //For new added employee
    var filteredEmployees = [Employee]() //For search bar
    
    var ref: DatabaseReference!
    
    var forkliftEmployees: [Employee] = []
    var deliveryEmployees: [Employee] = []
    var warehouseAssistantEmployees: [Employee] = []
    var deliveryAssistantEmployees: [Employee] = []
    
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
        //readForkliftEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            readForkliftEmployees()
        case 1:
            readDeliveryEmployees()
        case 2:
            readWarehouseEmployees()
        case 3:
            readDeliveryAssistantEmployees()
        default:
            print("Other case")
        }
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
            readForkliftEmployees()
        case 1:
            readDeliveryEmployees()
        case 2:
            readWarehouseEmployees()
        case 3:
            readDeliveryAssistantEmployees()
        default:
            print("Other case")
        }
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
    
    func readForkliftEmployees() {
        ref.child("forkliftEmployees").observe(DataEventType.value) { (snapshot) in
            self.forkliftEmployees.removeAll()
            self.orderEmployees(employeesArray: self.forkliftEmployees)
            self.tableView.reloadData()
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                let id = values!["employeeId"] as? String ?? ""
                var forkliftEmployee = Employee(name: name, lastName: lastname, type: .forklift)
                forkliftEmployee.id = id
                let photoURL = values!["photo"] as? String ?? ""
                forkliftEmployee.photoURL = photoURL
                //General
                let cultureAttatchmentArray = values!["cultureAttatchmentArray"] as? [Float] ?? []
                let cultureAttatchmentIndicator = values!["cultureAttatchmentIndicator"] as? Bool ?? true
                let dpoImplementationArray = values!["dpoImplementationArray"] as? [Float] ?? []
                let dpoImplementationIndicator = values!["dpoImplementationIndicator"] as? Bool ?? true
                let attitudeArray = values!["attitudeArray"] as? [Float] ?? []
                let attitudeIndicator = values!["attitudeIndicator"] as? Bool ?? true
                let trainingAdaptationArray = values!["trainingAdaptationArray"] as? [Float] ?? []
                let trainingAdaptationIndicator = values!["trainingAdaptationIndicator"] as? Bool ?? true
                let performanceArray = values!["performanceArray"] as? [Float] ?? []
                let performanceIndicator = values!["performanceIndicator"] as? Bool ?? true
                //Specific
                let firstSpecificGradeArray = values!["firstSpecificGradeArray"] as? [Float] ?? []
                let firstSpecificGradeIndicator = values!["firstSpecificGradeIndicator"] as? Bool ?? true
                let secondSpecificGradeArray = values!["secondSpecificGradeArray"] as? [Float] ?? []
                let secondSpecificGradeIndicator = values!["secondSpecificGradeIndicator"] as? Bool ?? true
                let thirdSpecificGradeArray = values!["thirdSpecificGradeArray"] as? [Float] ?? []
                let thirdSpecificGradeIndicator = values!["thirdSpecificGradeIndicator"] as? Bool ?? true
                let fourthSpecificGradeArray = values!["fourthSpecificGradeArray"] as? [Float] ?? []
                let fourthSpecificGradeIndicator = values!["fourthSpecificGradeIndicator"] as? Bool ?? true
                let fifthSpecificGradeArray = values!["fifthSpecificGradeArray"] as? [Float] ?? []
                let fifthSpecificGradeIndicator = values!["fifthSpecificGradeIndicator"] as? Bool ?? true
                let sixthSpecificGradeArray = values!["sixthSpecificGradeArray"] as? [Float] ?? []
                let sixthSpecificGradeIndicator = values!["sixthSpecificGradeIndicator"] as? Bool ?? true
                //Average
                let averageArray = values!["averageArray"] as? [Float] ?? []
                let averageIndicator = values!["averageIndicator"] as? Bool ?? true
                //Build employee
                forkliftEmployee.cultureAttatchmentArray = cultureAttatchmentArray
                forkliftEmployee.cultureAttatchmentIndicator = cultureAttatchmentIndicator
                forkliftEmployee.dpoImplementationArray = dpoImplementationArray
                forkliftEmployee.dpoImplementationIndicator = dpoImplementationIndicator
                forkliftEmployee.attitudeArray = attitudeArray
                forkliftEmployee.attitudeIndicator = attitudeIndicator
                forkliftEmployee.trainingAdaptationArray = trainingAdaptationArray
                forkliftEmployee.trainingAdaptationIndicator = trainingAdaptationIndicator
                forkliftEmployee.performanceArray = performanceArray
                forkliftEmployee.performanceIndicator = performanceIndicator
                forkliftEmployee.firstSpecificGradeArray = firstSpecificGradeArray
                forkliftEmployee.firstSpecificGradeIndicator = firstSpecificGradeIndicator
                forkliftEmployee.secondSpecificGradeArray = secondSpecificGradeArray
                forkliftEmployee.secondSpecificGradeIndicator = secondSpecificGradeIndicator
                forkliftEmployee.thirdSpecificGradeArray = thirdSpecificGradeArray
                forkliftEmployee.thirdSpecificGradeIndicator = thirdSpecificGradeIndicator
                forkliftEmployee.fourthSpecificGradeArray = fourthSpecificGradeArray
                forkliftEmployee.fourthSpecificGradeIndicator = fourthSpecificGradeIndicator
                forkliftEmployee.fifthSpecificGradeArray = fifthSpecificGradeArray
                forkliftEmployee.fifthSpecificGradeIndicator = fifthSpecificGradeIndicator
                forkliftEmployee.sixthSpecificGradeArray = sixthSpecificGradeArray
                forkliftEmployee.sixthSpecificGradeIndicator = sixthSpecificGradeIndicator
                forkliftEmployee.averageArray = averageArray
                forkliftEmployee.averageIndicator = averageIndicator
                //Image
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            forkliftEmployee.photo = UIImage(data: imageData)!
                            self.forkliftEmployees.append(forkliftEmployee)
                            print("Total forklift: \(self.forkliftEmployees.count)")
                            //self.orderEmployees(employeesArray: self.forkliftEmployees)
                            DispatchQueue.main.async {
                                self.orderEmployees(employeesArray: self.forkliftEmployees)
                                self.tableView.reloadData()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func readDeliveryEmployees() {
        ref.child("deliveryEmployees").observe(DataEventType.value) { (snapshot) in
            self.deliveryEmployees.removeAll()
            self.orderEmployees(employeesArray: self.deliveryEmployees)
            self.tableView.reloadData()
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                let id = values!["employeeId"] as? String ?? ""
                var deliveryEmployee = Employee(name: name, lastName: lastname, type: .delivery)
                deliveryEmployee.id = id
                let photoURL = values!["photo"] as? String ?? ""
                deliveryEmployee.photoURL = photoURL
                //General
                let cultureAttatchmentArray = values!["cultureAttatchmentArray"] as? [Float] ?? []
                let cultureAttatchmentIndicator = values!["cultureAttatchmentIndicator"] as? Bool ?? true
                let dpoImplementationArray = values!["dpoImplementationArray"] as? [Float] ?? []
                let dpoImplementationIndicator = values!["dpoImplementationIndicator"] as? Bool ?? true
                let attitudeArray = values!["attitudeArray"] as? [Float] ?? []
                let attitudeIndicator = values!["attitudeIndicator"] as? Bool ?? true
                let trainingAdaptationArray = values!["trainingAdaptationArray"] as? [Float] ?? []
                let trainingAdaptationIndicator = values!["trainingAdaptationIndicator"] as? Bool ?? true
                let performanceArray = values!["performanceArray"] as? [Float] ?? []
                let performanceIndicator = values!["performanceIndicator"] as? Bool ?? true
                //Specific
                let firstSpecificGradeArray = values!["firstSpecificGradeArray"] as? [Float] ?? []
                let firstSpecificGradeIndicator = values!["firstSpecificGradeIndicator"] as? Bool ?? true
                let secondSpecificGradeArray = values!["secondSpecificGradeArray"] as? [Float] ?? []
                let secondSpecificGradeIndicator = values!["secondSpecificGradeIndicator"] as? Bool ?? true
                let thirdSpecificGradeArray = values!["thirdSpecificGradeArray"] as? [Float] ?? []
                let thirdSpecificGradeIndicator = values!["thirdSpecificGradeIndicator"] as? Bool ?? true
                let fourthSpecificGradeArray = values!["fourthSpecificGradeArray"] as? [Float] ?? []
                let fourthSpecificGradeIndicator = values!["fourthSpecificGradeIndicator"] as? Bool ?? true
                let fifthSpecificGradeArray = values!["fifthSpecificGradeArray"] as? [Float] ?? []
                let fifthSpecificGradeIndicator = values!["fifthSpecificGradeIndicator"] as? Bool ?? true
                let sixthSpecificGradeArray = values!["sixthSpecificGradeArray"] as? [Float] ?? []
                let sixthSpecificGradeIndicator = values!["sixthSpecificGradeIndicator"] as? Bool ?? true
                //Average
                let averageArray = values!["averageArray"] as? [Float] ?? []
                let averageIndicator = values!["averageIndicator"] as? Bool ?? true
                //Build employee
                deliveryEmployee.cultureAttatchmentArray = cultureAttatchmentArray
                deliveryEmployee.cultureAttatchmentIndicator = cultureAttatchmentIndicator
                deliveryEmployee.dpoImplementationArray = dpoImplementationArray
                deliveryEmployee.dpoImplementationIndicator = dpoImplementationIndicator
                deliveryEmployee.attitudeArray = attitudeArray
                deliveryEmployee.attitudeIndicator = attitudeIndicator
                deliveryEmployee.trainingAdaptationArray = trainingAdaptationArray
                deliveryEmployee.trainingAdaptationIndicator = trainingAdaptationIndicator
                deliveryEmployee.performanceArray = performanceArray
                deliveryEmployee.performanceIndicator = performanceIndicator
                deliveryEmployee.firstSpecificGradeArray = firstSpecificGradeArray
                deliveryEmployee.firstSpecificGradeIndicator = firstSpecificGradeIndicator
                deliveryEmployee.secondSpecificGradeArray = secondSpecificGradeArray
                deliveryEmployee.secondSpecificGradeIndicator = secondSpecificGradeIndicator
                deliveryEmployee.thirdSpecificGradeArray = thirdSpecificGradeArray
                deliveryEmployee.thirdSpecificGradeIndicator = thirdSpecificGradeIndicator
                deliveryEmployee.fourthSpecificGradeArray = fourthSpecificGradeArray
                deliveryEmployee.fourthSpecificGradeIndicator = fourthSpecificGradeIndicator
                deliveryEmployee.fifthSpecificGradeArray = fifthSpecificGradeArray
                deliveryEmployee.fifthSpecificGradeIndicator = fifthSpecificGradeIndicator
                deliveryEmployee.sixthSpecificGradeArray = sixthSpecificGradeArray
                deliveryEmployee.sixthSpecificGradeIndicator = sixthSpecificGradeIndicator
                deliveryEmployee.averageArray = averageArray
                deliveryEmployee.averageIndicator = averageIndicator
                //Image
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            deliveryEmployee.photo = UIImage(data: imageData)!
                            self.deliveryEmployees.append(deliveryEmployee)
                            print("Total delivery: \(self.deliveryEmployees.count)")
                            //self.orderEmployees(employeesArray: self.forkliftEmployees)
                            DispatchQueue.main.async {
                                self.orderEmployees(employeesArray: self.deliveryEmployees)
                                self.tableView.reloadData()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func readWarehouseEmployees() {
        ref.child("warehouseAssistantEmployees").observe(DataEventType.value) { (snapshot) in
            self.warehouseAssistantEmployees.removeAll()
            self.orderEmployees(employeesArray: self.warehouseAssistantEmployees)
            self.tableView.reloadData()
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                let id = values!["employeeId"] as? String ?? ""
                var warehouseEmployee = Employee(name: name, lastName: lastname, type: .warehouseAssistant)
                warehouseEmployee.id = id
                let photoURL = values!["photo"] as? String ?? ""
                warehouseEmployee.photoURL = photoURL
                //General
                let cultureAttatchmentArray = values!["cultureAttatchmentArray"] as? [Float] ?? []
                let cultureAttatchmentIndicator = values!["cultureAttatchmentIndicator"] as? Bool ?? true
                let dpoImplementationArray = values!["dpoImplementationArray"] as? [Float] ?? []
                let dpoImplementationIndicator = values!["dpoImplementationIndicator"] as? Bool ?? true
                let attitudeArray = values!["attitudeArray"] as? [Float] ?? []
                let attitudeIndicator = values!["attitudeIndicator"] as? Bool ?? true
                let trainingAdaptationArray = values!["trainingAdaptationArray"] as? [Float] ?? []
                let trainingAdaptationIndicator = values!["trainingAdaptationIndicator"] as? Bool ?? true
                let performanceArray = values!["performanceArray"] as? [Float] ?? []
                let performanceIndicator = values!["performanceIndicator"] as? Bool ?? true
                //Specific
                let firstSpecificGradeArray = values!["firstSpecificGradeArray"] as? [Float] ?? []
                let firstSpecificGradeIndicator = values!["firstSpecificGradeIndicator"] as? Bool ?? true
                let secondSpecificGradeArray = values!["secondSpecificGradeArray"] as? [Float] ?? []
                let secondSpecificGradeIndicator = values!["secondSpecificGradeIndicator"] as? Bool ?? true
                let thirdSpecificGradeArray = values!["thirdSpecificGradeArray"] as? [Float] ?? []
                let thirdSpecificGradeIndicator = values!["thirdSpecificGradeIndicator"] as? Bool ?? true
                let fourthSpecificGradeArray = values!["fourthSpecificGradeArray"] as? [Float] ?? []
                let fourthSpecificGradeIndicator = values!["fourthSpecificGradeIndicator"] as? Bool ?? true
                let fifthSpecificGradeArray = values!["fifthSpecificGradeArray"] as? [Float] ?? []
                let fifthSpecificGradeIndicator = values!["fifthSpecificGradeIndicator"] as? Bool ?? true
                let sixthSpecificGradeArray = values!["sixthSpecificGradeArray"] as? [Float] ?? []
                let sixthSpecificGradeIndicator = values!["sixthSpecificGradeIndicator"] as? Bool ?? true
                //Average
                let averageArray = values!["averageArray"] as? [Float] ?? []
                let averageIndicator = values!["averageIndicator"] as? Bool ?? true
                //Build employee
                warehouseEmployee.cultureAttatchmentArray = cultureAttatchmentArray
                warehouseEmployee.cultureAttatchmentIndicator = cultureAttatchmentIndicator
                warehouseEmployee.dpoImplementationArray = dpoImplementationArray
                warehouseEmployee.dpoImplementationIndicator = dpoImplementationIndicator
                warehouseEmployee.attitudeArray = attitudeArray
                warehouseEmployee.attitudeIndicator = attitudeIndicator
                warehouseEmployee.trainingAdaptationArray = trainingAdaptationArray
                warehouseEmployee.trainingAdaptationIndicator = trainingAdaptationIndicator
                warehouseEmployee.performanceArray = performanceArray
                warehouseEmployee.performanceIndicator = performanceIndicator
                warehouseEmployee.firstSpecificGradeArray = firstSpecificGradeArray
                warehouseEmployee.firstSpecificGradeIndicator = firstSpecificGradeIndicator
                warehouseEmployee.secondSpecificGradeArray = secondSpecificGradeArray
                warehouseEmployee.secondSpecificGradeIndicator = secondSpecificGradeIndicator
                warehouseEmployee.thirdSpecificGradeArray = thirdSpecificGradeArray
                warehouseEmployee.thirdSpecificGradeIndicator = thirdSpecificGradeIndicator
                warehouseEmployee.fourthSpecificGradeArray = fourthSpecificGradeArray
                warehouseEmployee.fourthSpecificGradeIndicator = fourthSpecificGradeIndicator
                warehouseEmployee.fifthSpecificGradeArray = fifthSpecificGradeArray
                warehouseEmployee.fifthSpecificGradeIndicator = fifthSpecificGradeIndicator
                warehouseEmployee.sixthSpecificGradeArray = sixthSpecificGradeArray
                warehouseEmployee.sixthSpecificGradeIndicator = sixthSpecificGradeIndicator
                warehouseEmployee.averageArray = averageArray
                warehouseEmployee.averageIndicator = averageIndicator
                //Image
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            warehouseEmployee.photo = UIImage(data: imageData)!
                            self.warehouseAssistantEmployees.append(warehouseEmployee)
                            print("Total warehouse: \(self.warehouseAssistantEmployees.count)")
                            //self.orderEmployees(employeesArray: self.forkliftEmployees)
                            DispatchQueue.main.async {
                                self.orderEmployees(employeesArray: self.warehouseAssistantEmployees)
                                self.tableView.reloadData()
                            }
                        }
                    }
                })
            }
        }
    }
    
    func readDeliveryAssistantEmployees() {
        ref.child("deliveryAssistantEmployees").observe(DataEventType.value) { (snapshot) in
            self.deliveryAssistantEmployees.removeAll()
            self.orderEmployees(employeesArray: self.deliveryAssistantEmployees)
            self.tableView.reloadData()
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                let id = values!["employeeId"] as? String ?? ""
                var deliveryAssistantEmployee = Employee(name: name, lastName: lastname, type: .deliveryAssistant)
                deliveryAssistantEmployee.id = id
                let photoURL = values!["photo"] as? String ?? ""
                deliveryAssistantEmployee.photoURL = photoURL
                //General
                let cultureAttatchmentArray = values!["cultureAttatchmentArray"] as? [Float] ?? []
                let cultureAttatchmentIndicator = values!["cultureAttatchmentIndicator"] as? Bool ?? true
                let dpoImplementationArray = values!["dpoImplementationArray"] as? [Float] ?? []
                let dpoImplementationIndicator = values!["dpoImplementationIndicator"] as? Bool ?? true
                let attitudeArray = values!["attitudeArray"] as? [Float] ?? []
                let attitudeIndicator = values!["attitudeIndicator"] as? Bool ?? true
                let trainingAdaptationArray = values!["trainingAdaptationArray"] as? [Float] ?? []
                let trainingAdaptationIndicator = values!["trainingAdaptationIndicator"] as? Bool ?? true
                let performanceArray = values!["performanceArray"] as? [Float] ?? []
                let performanceIndicator = values!["performanceIndicator"] as? Bool ?? true
                //Specific
                let firstSpecificGradeArray = values!["firstSpecificGradeArray"] as? [Float] ?? []
                let firstSpecificGradeIndicator = values!["firstSpecificGradeIndicator"] as? Bool ?? true
                let secondSpecificGradeArray = values!["secondSpecificGradeArray"] as? [Float] ?? []
                let secondSpecificGradeIndicator = values!["secondSpecificGradeIndicator"] as? Bool ?? true
                let thirdSpecificGradeArray = values!["thirdSpecificGradeArray"] as? [Float] ?? []
                let thirdSpecificGradeIndicator = values!["thirdSpecificGradeIndicator"] as? Bool ?? true
                let fourthSpecificGradeArray = values!["fourthSpecificGradeArray"] as? [Float] ?? []
                let fourthSpecificGradeIndicator = values!["fourthSpecificGradeIndicator"] as? Bool ?? true
                let fifthSpecificGradeArray = values!["fifthSpecificGradeArray"] as? [Float] ?? []
                let fifthSpecificGradeIndicator = values!["fifthSpecificGradeIndicator"] as? Bool ?? true
                let sixthSpecificGradeArray = values!["sixthSpecificGradeArray"] as? [Float] ?? []
                let sixthSpecificGradeIndicator = values!["sixthSpecificGradeIndicator"] as? Bool ?? true
                //Average
                let averageArray = values!["averageArray"] as? [Float] ?? []
                let averageIndicator = values!["averageIndicator"] as? Bool ?? true
                //Build employee
                deliveryAssistantEmployee.cultureAttatchmentArray = cultureAttatchmentArray
                deliveryAssistantEmployee.cultureAttatchmentIndicator = cultureAttatchmentIndicator
                deliveryAssistantEmployee.dpoImplementationArray = dpoImplementationArray
                deliveryAssistantEmployee.dpoImplementationIndicator = dpoImplementationIndicator
                deliveryAssistantEmployee.attitudeArray = attitudeArray
                deliveryAssistantEmployee.attitudeIndicator = attitudeIndicator
                deliveryAssistantEmployee.trainingAdaptationArray = trainingAdaptationArray
                deliveryAssistantEmployee.trainingAdaptationIndicator = trainingAdaptationIndicator
                deliveryAssistantEmployee.performanceArray = performanceArray
                deliveryAssistantEmployee.performanceIndicator = performanceIndicator
                deliveryAssistantEmployee.firstSpecificGradeArray = firstSpecificGradeArray
                deliveryAssistantEmployee.firstSpecificGradeIndicator = firstSpecificGradeIndicator
                deliveryAssistantEmployee.secondSpecificGradeArray = secondSpecificGradeArray
                deliveryAssistantEmployee.secondSpecificGradeIndicator = secondSpecificGradeIndicator
                deliveryAssistantEmployee.thirdSpecificGradeArray = thirdSpecificGradeArray
                deliveryAssistantEmployee.thirdSpecificGradeIndicator = thirdSpecificGradeIndicator
                deliveryAssistantEmployee.fourthSpecificGradeArray = fourthSpecificGradeArray
                deliveryAssistantEmployee.fourthSpecificGradeIndicator = fourthSpecificGradeIndicator
                deliveryAssistantEmployee.fifthSpecificGradeArray = fifthSpecificGradeArray
                deliveryAssistantEmployee.fifthSpecificGradeIndicator = fifthSpecificGradeIndicator
                deliveryAssistantEmployee.sixthSpecificGradeArray = sixthSpecificGradeArray
                deliveryAssistantEmployee.sixthSpecificGradeIndicator = sixthSpecificGradeIndicator
                deliveryAssistantEmployee.averageArray = averageArray
                deliveryAssistantEmployee.averageIndicator = averageIndicator
                //Image
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            deliveryAssistantEmployee.photo = UIImage(data: imageData)!
                            self.deliveryAssistantEmployees.append(deliveryAssistantEmployee)
                            print("Total delivery assistant: \(self.deliveryAssistantEmployees.count)")
                            //self.orderEmployees(employeesArray: self.forkliftEmployees)
                            DispatchQueue.main.async {
                                self.orderEmployees(employeesArray: self.deliveryAssistantEmployees)
                                self.tableView.reloadData()
                            }
                        }
                    }
                })
            }
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
        print("Employee added: \(employee)")
        
        switch employee.type {
        case .forklift:
            //Save image in storage
            let storage = Storage.storage().reference()
            let imageName = UUID()
            let forkliftDirectory = storage.child("forkliftProfileImages/\(imageName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            guard let data = employee.photo.jpegData(compressionQuality: 0.95) else { return }
            forkliftDirectory.putData(data, metadata: metadata) { (data, error) in
                if error == nil {
                    print("Forklift employee profile image saved.")
                } else {
                    if let error = error?.localizedDescription {
                        print("Firebase error: \(error)")
                    } else {
                        print("Code error")
                    }
                }
            }
            
            //Save in database
            guard let idForkliftEmployee = ref.childByAutoId().key else { return } //Generic id
            let fields: [String: Any] = ["photo": String(describing: forkliftDirectory),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": idForkliftEmployee,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            
            ref.child("forkliftEmployees").child(idForkliftEmployee).setValue(fields)
        case .delivery:
            //Save image in storage
            let storage = Storage.storage().reference()
            let imageName = UUID()
            let deliveryDirectory = storage.child("deliveryProfileImages/\(imageName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            guard let data = employee.photo.jpegData(compressionQuality: 0.95) else { return }
            deliveryDirectory.putData(data, metadata: metadata) { (data, error) in
                if error == nil {
                    print("Delivery employee profile image saved.")
                } else {
                    if let error = error?.localizedDescription {
                        print("Firebase error: \(error)")
                    } else {
                        print("Code error")
                    }
                }
            }
            
            //Save in database
            guard let idDeliveryEmployee = ref.childByAutoId().key else { return } //Generic id
            let fields: [String: Any] = ["photo": String(describing: deliveryDirectory),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": idDeliveryEmployee,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            
            ref.child("deliveryEmployees").child(idDeliveryEmployee).setValue(fields)
        case .warehouseAssistant:
            //Save image in storage
            let storage = Storage.storage().reference()
            let imageName = UUID()
            let warehouseAssistantDirectory = storage.child("warehouseAssistantProfileImages/\(imageName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            guard let data = employee.photo.jpegData(compressionQuality: 0.95) else { return }
            warehouseAssistantDirectory.putData(data, metadata: metadata) { (data, error) in
                if error == nil {
                    print("Warehouse assistant employee profile image saved.")
                } else {
                    if let error = error?.localizedDescription {
                        print("Firebase error: \(error)")
                    } else {
                        print("Code error")
                    }
                }
            }
            
            //Save in database
            guard let idWarehouseAssistantEmployee = ref.childByAutoId().key else { return } //Generic id
            let fields: [String: Any] = ["photo": String(describing: warehouseAssistantDirectory),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": idWarehouseAssistantEmployee,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            
            ref.child("warehouseAssistantEmployees").child(idWarehouseAssistantEmployee).setValue(fields)
        case .deliveryAssistant:
            //Save image in storage
            let storage = Storage.storage().reference()
            let imageName = UUID()
            let deliveryAssistantDirectory = storage.child("deliveryAssistantProfileImages/\(imageName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            guard let data = employee.photo.jpegData(compressionQuality: 0.95) else { return }
            deliveryAssistantDirectory.putData(data, metadata: metadata) { (data, error) in
                if error == nil {
                    print("Delivery assistant employee profile image saved.")
                } else {
                    if let error = error?.localizedDescription {
                        print("Firebase error: \(error)")
                    } else {
                        print("Code error")
                    }
                }
            }
            
            //Save in database
            guard let idDeliveryAssistantEmployee = ref.childByAutoId().key else { return } //Generic id
            let fields: [String: Any] = ["photo": String(describing: deliveryAssistantDirectory),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": idDeliveryAssistantEmployee,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            
            ref.child("deliveryAssistantEmployees").child(idDeliveryAssistantEmployee).setValue(fields)
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
            let fields: [String: Any] = ["photo": String(describing: employee.photoURL),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": employee.id,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            ref.child("forkliftEmployees").child(employee.id).setValue(fields)
        case .delivery:
            for (index, oldEmployee) in deliveryEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    deliveryEmployees[index] = employee
                }
            }
            let fields: [String: Any] = ["photo": String(describing: employee.photoURL),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": employee.id,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            ref.child("deliveryEmployees").child(employee.id).setValue(fields)
        case .warehouseAssistant:
            for (index, oldEmployee) in warehouseAssistantEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    warehouseAssistantEmployees[index] = employee
                }
            }
            let fields: [String: Any] = ["photo": String(describing: employee.photoURL),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": employee.id,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            ref.child("warehouseAssistantEmployees").child(employee.id).setValue(fields)
        case .deliveryAssistant:
            for (index, oldEmployee) in deliveryAssistantEmployees.enumerated() {
                if(oldEmployee.name == employee.name && oldEmployee.lastName == employee.lastName) {
                    deliveryAssistantEmployees[index] = employee
                }
            }
            let fields: [String: Any] = ["photo": String(describing: employee.photoURL),
                                         "name": employee.name,
                                         "lastName": employee.lastName,
                                         "hasBeenEvaluated": employee.hasBeenEvaluated,
                                         "employeeId": employee.id,
                                         "cultureAttatchmentArray": employee.cultureAttatchmentArray,
                                         "cultureAttatchmentIndicator": employee.cultureAttatchmentIndicator,
                                         "dpoImplementationArray": employee.dpoImplementationArray,
                                         "dpoImplementationIndicator": employee.dpoImplementationIndicator,
                                         "attitudeArray": employee.attitudeArray,
                                         "attitudeIndicator": employee.attitudeIndicator,
                                         "trainingAdaptationArray": employee.trainingAdaptationArray,
                                         "trainingAdaptationIndicator": employee.trainingAdaptationIndicator,
                                         "performanceArray": employee.performanceArray,
                                         "performanceIndicator": employee.performanceIndicator,
                                         "firstSpecificGradeArray": employee.firstSpecificGradeArray,
                                         "firstSpecificGradeIndicator": employee.firstSpecificGradeIndicator,
                                         "secondSpecificGradeArray": employee.secondSpecificGradeArray,
                                         "secondSpecificGradeIndicator": employee.secondSpecificGradeIndicator,
                                         "thirdSpecificGradeArray": employee.thirdSpecificGradeArray,
                                         "thirdSpecificGradeIndicator": employee.thirdSpecificGradeIndicator,
                                         "fourthSpecificGradeArray": employee.fourthSpecificGradeArray,
                                         "fourthSpecificGradeIndicator": employee.fourthSpecificGradeIndicator,
                                         "fifthSpecificGradeArray": employee.fifthSpecificGradeArray,
                                         "fifthSpecificGradeIndicator": employee.fifthSpecificGradeIndicator,
                                         "sixthSpecificGradeArray": employee.sixthSpecificGradeArray,
                                         "sixthSpecificGradeIndicator": employee.sixthSpecificGradeIndicator,
                                         "averageArray": employee.averageArray,
                                         "averageIndicator": employee.averageIndicator]
            ref.child("deliveryAssistantEmployees").child(employee.id).setValue(fields)
        }
    }
}

//For order employees alphabetically
struct Section {
    let letter: String
    var employees: [Employee]
}
