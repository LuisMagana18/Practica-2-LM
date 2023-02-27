//
//  ViewController.swift
//  Practica 2
//
//  Created by Luis Angel Magaña on 27/02/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cocktail: Resultado?
    var imgPickCon : UIImagePickerController?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var preparacion: UITextView!
    @IBOutlet weak var ingredientes: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if InternetMonitor.instance.internetStatus {
            if let laURL = URL(string:"http://janzelaznog.com/DDAM/iOS/drinksimages/") {
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
                        DispatchQueue.main.async {
                            self.img.image = UIImage(data: data)
                        }
                    }
                }
                // iniciamos la tarea
                task.resume()
            }
        }
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let objetoUW = cocktail{
            let stringURL = objetoUW.img
            guard let url = URL(string: stringURL) else {return}
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request){data, response, error in
                if error == nil{
                    guard let data = data else {return}
                    DispatchQueue.main.async {
                        self.name.text = objetoUW.name
                        self.ingredientes.text = objetoUW.ingredients
                        self.preparacion.text = objetoUW.directions
                        self.img.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }*/
    
    
    

    @IBAction func tomarFoto(_ sender: UIButton) {
        imgPickCon = UIImagePickerController()
               imgPickCon?.delegate = self
               imgPickCon?.allowsEditing = true
               
               if UIImagePickerController.isSourceTypeAvailable(.camera) {
                   switch AVCaptureDevice.authorizationStatus(for:.video) {
                   case .authorized:self.launchIMGPC(.camera)
                   case .notDetermined:AVCaptureDevice.requestAccess (for: .video) { permiso in
                                if permiso {
                                    self.launchIMGPC(.camera)
                                           }
                                else {
                                    self.launchIMGPC(.photoLibrary)
                                        }
                            }
                   default:
                       permisos()
                       return
                   }
               }
               else {
                   self.launchIMGPC(.photoLibrary)
               }
    }
    
    func permisos () {
        let ac = UIAlertController(title: "", message:"Se requiere permiso para usar la cámara. Puede configurarlo desde settings ahora", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .default) {
            alertaction in
            if let laURL = URL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(laURL)
                }
            }
        let action2 = UIAlertAction(title: "NO", style: .destructive)
            ac.addAction(action)
            ac.addAction(action2)
            self.present(ac, animated: true)
        }
        
        func launchIMGPC (_ type:UIImagePickerController.SourceType) {
            DispatchQueue.main.async {
                self.imgPickCon?.sourceType = type
                self.present(self.imgPickCon!, animated: true)
            }
        }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
        let isModal = self.presentingViewController is UINavigationController
        
        if isModal{
            self.dismiss(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}

