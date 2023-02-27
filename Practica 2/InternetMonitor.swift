//
//  InternetMonitor.swift
//  Practica 2
//
//  Created by Luis Angel Magaña on 28/02/23.
//

import Foundation
import Network

// Por si se necesita que esta clase implemente algun protocolo, es mejor que herede explicitamente de NSObject
class InternetMonitor: NSObject {
    
    var internetStatus = false
    var internetType = ""
    
    // Implementación Singleton
    // 1) debe haber una única instancia
    static let instance = InternetMonitor()
    // 2) para garantizar que esta clase no se pueda instanciar
    override private init() {
        super.init()
        startDetection()
    }
    
    func startDetection() {
        let monitor = NWPathMonitor()
        // ....
        monitor.start(queue:DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // ejecutar un Ping para alcanzar el host que nos interesa (TODO: buscar un paquete que haga eso....)
                self.internetStatus = true
                if path.usesInterfaceType(.wifi) {
                    self.internetType = "WiFi"
                }
                else {
                    self.internetType = "no WiFi"
                }
            }
            else {
                self.internetStatus = false
                self.internetType = ""
            }
        }
    }
}
