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
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                var forkliftEmployee = Employee(name: name, lastName: lastname, type: .forklift)
                let photoURL = values!["photo"] as? String ?? ""
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            print("Correct image data")
                            forkliftEmployee.photo = UIImage(data: imageData)!
                            self.forkliftEmployees.append(forkliftEmployee)
                            print("Total: \(self.forkliftEmployees.count)")
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
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                var deliveryEmployee = Employee(name: name, lastName: lastname, type: .delivery)
                let photoURL = values!["photo"] as? String ?? ""
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            print("Correct image data")
                            deliveryEmployee.photo = UIImage(data: imageData)!
                            self.deliveryEmployees.append(deliveryEmployee)
                            print("Total: \(self.deliveryEmployees.count)")
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
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                var warehouseEmployee = Employee(name: name, lastName: lastname, type: .warehouseAssistant)
                let photoURL = values!["photo"] as? String ?? ""
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            print("Correct image data")
                            warehouseEmployee.photo = UIImage(data: imageData)!
                            self.warehouseAssistantEmployees.append(warehouseEmployee)
                            print("Total: \(self.warehouseAssistantEmployees.count)")
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
            for employee in snapshot.children.allObjects as! [DataSnapshot] {
                let values = employee.value as? [String: AnyObject]
                let name = values!["name"] as? String ?? ""
                let lastname = values!["lastName"] as? String ?? ""
                var deliveryAssistantEmployee = Employee(name: name, lastName: lastname, type: .deliveryAssistant)
                let photoURL = values!["photo"] as? String ?? ""
                let imageStorage = Storage.storage().reference(forURL: photoURL)
                imageStorage.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if let error = error?.localizedDescription {
                        print("Error while downloading image: \(error)")
                    } else {
                        if let imageData = data {
                            print("Correct image data")
                            deliveryAssistantEmployee.photo = UIImage(data: imageData)!
                            self.deliveryAssistantEmployees.append(deliveryAssistantEmployee)
                            print("Total: \(self.deliveryAssistantEmployees.count)")
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
            //guard let data = employee.photo.jpegData(compressionQuality: 0.95) else { return }
            forkliftDirectory.putData(employee.photo.pngData()!, metadata: metadata) { (data, error) in
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
