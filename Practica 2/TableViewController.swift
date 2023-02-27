//
//  TableViewController.swift
//  Practica 2
//
//  Created by Luis Angel Magaña on 27/02/23.
//

import UIKit

class TableViewController: UITableViewController {

    var objeto = [Resultado] ()
    lazy var urlLocal: URL? = {
            var tmp = URL(string: "")
            if let documentsURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first {
                tmp = documentsURL.appendingPathComponent("drinks.json")
            }
            return tmp
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Validamos si el archivo existe localmente
        if FileManager.default.fileExists(atPath:urlLocal?.path ?? "") {
            let elReq = URLRequest(url: urlLocal!)
        }
        else {
            // El archivo no existe, descargarlo y guardarlo
            if InternetMonitor.instance.internetStatus {
                // si hay conexion a Internet
                guard let laURL = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json") else { return }
                // Implementación de descarga en background con URLSession
                //1. Establecemos la configuracion para la sesión o usamos la basica
                let configuration = URLSessionConfiguration.ephemeral
                //2.Creamos la sesión de descarga, con la configuración elegida
                let session = URLSession(configuration: configuration)
                //3. Creamos el request para especificar lo que queremos obtener
                let elReq = URLRequest (url: laURL)
                //4. Creamos la tarea especifica de descarga
                let task = session.dataTask(with: elReq) { bytes, response, error in
                    // Que queremos que pase al recibir el response:
                    if error == nil {
                        guard let data = bytes else { return }
                        do {
                            try data.write(to:self.urlLocal!)
                        }
                        catch {
                            print ("Error al guardar el archivo " + String(describing: error))
                        }
                    }
                }
                // iniciamos la tarea
                task.resume()
            }
        }
    }
    
    
    
    /* override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         //Consultar API y serializar el JSON
         guard let laUrl = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks") else {return}
         do{
             let bytes = try Data(contentsOf: laUrl)
             let coctel = try? JSONDecoder().decode(Coctel.self, from: bytes)
             objeto = coctel!.resultado
             self.tableView.reloadData()
         }catch{
             print("Error al descargar el JSON: " + String(describing: error))
         }
     }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let url = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json")
            let configuration = URLSessionConfiguration.default
            //let session = URLSession(configuration: configuration)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request){data, response,
                   error in
            guard let data = try? Data(contentsOf: url!)
            else {
                   print("Error \(String(describing: error))")
                   return
                   }
                   do {
                       print("Recibimos respuesta")
                       let decoder = JSONDecoder() //Agregamos una variable de tipo JSONDecoder
                           DispatchQueue.main.async{
                               let json = try? decoder.decode(Coctel.self, from: data)//Decodificamos la data de tipo JSON en la estructura Decodable
                               print(json ?? "No los jala")
                           }
                   } catch  {
                       print("Error de parseo \(String(describing: error))")
                       let responseString = String(data: data, encoding: .utf8)
                       print("respuesta: \(String(describing: responseString))")
                   }
               }
               task.resume()
        
       /* let task = URLSession.shared.dataTask(with: request) { jsondata, response, error in
                if error == nil {
                    guard let jsonData = try? Data(contentsOf: url!) else { return }
                   
                    

                    DispatchQueue.main.async {
                        
                        let coctel = try? JSONDecoder().decode(Coctel.self, from: jsonData)
                                           print(coctel)
                                           guard let cockteles = coctel else { return }
                                           self.objeto = cockteles.resultado
                        self.tableView.reloadData()
                    }
                    
                }
            }
            task.resume()*/
    }
    
 /*   let task = URLSession.shared.dataTask(with: request){data, response,
            error in guard let data = data else {
            print("Error \(String(describing: error))")
            return
            }
            do {
                print("Recibimos respuesta")
                let decoder = JSONDecoder() //Agregamos una variable de tipo JSONDecoder
                    DispatchQueue.main.async {
                        let json = try decoder.decode(TuStruct.self, from: data)//Decodificamos la data de tipo JSON en la estructura Decodable
                        print(json)
                    }
            } catch  _{
                print("Error de parseo \(String(describing: error))")
                let responseString = String(data: data, encoding: .utf8)
                print("respuesta: \(String(describing: responseString))")
            }
        }
        task.resume()*/
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objeto.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objeto.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let unCoctel = objeto[indexPath.row]
        cell.textLabel?.text = unCoctel.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "show", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "show"){
            let detailViewControler = segue.destination as! ViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            var detailCoctel = objeto[indexPath.row]
            detailViewControler.cocktail = detailCoctel
        }
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
