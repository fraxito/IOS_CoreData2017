//
//  ViewController.swift
//  PruebaCoreData
//
//  Created by administrador on 20/2/17.
//  Copyright © 2017 administrador. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var alumnos: [NSManagedObject] = []
    
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Nuevo Suspenso", message: "Añade el próximo suspenso", preferredStyle: .alert)
        
        let guardarAction = UIAlertAction(title: "Guardar", style: .default){
            [unowned self] ACTION in
            guard let textoEscrito = alerta.textFields?.first,
                let nombreASalvar = textoEscrito.text else {return}
            
            self.guarda(nombre: nombreASalvar)
            self.tableView.reloadData()
        }
        
        let cancelarAction = UIAlertAction(title: "Cancela", style: .default)
        
        alerta.addTextField()
        
        alerta.addAction(guardarAction)
        alerta.addAction(cancelarAction)
        
        present(alerta, animated: true)
        
    }
    
    func guarda(nombre: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entidad = NSEntityDescription.entity(forEntityName: "Alumno", in: managedContext)
        
        let alumno = NSManagedObject(entity: entidad!, insertInto: managedContext)
        
        alumno.setValue(nombre, forKey: "nombre")
        
        do{
            try managedContext.save()
            alumnos.append(alumno)
            
        }   catch let error as NSError{
            print("No se ha podido salvar \(error), \(error.userInfo)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let cargaDatos = NSFetchRequest<NSManagedObject>(entityName: "Alumno")
        
        do{
            alumnos = try managedContext.fetch(cargaDatos)
        }   catch let error as NSError{
            print("No se ha podido salvar \(error), \(error.userInfo)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LA LISTA DE SUSPENSOS"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}


extension ViewController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return alumnos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let alumno = alumnos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = alumno.value(forKeyPath: "nombre") as? String
            
        return cell
    }
    
    
}
























