//
//  ViewController.swift
//  Login
//
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var TextFieldUser: UITextField!
    
    @IBOutlet weak var TextFieldPass: UITextField!
    
    @IBOutlet weak var ButtonLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func ButtonLoginAction(_ sender: UIButton) {
        comprobar(usuario: TextFieldUser.text!, pass: TextFieldPass.text!)
        print("Boton pulsado")
    }
    
    func comprobar(usuario : String , pass : String){
        var mensaje = ""
        if usuario.isEmpty {
            mensaje += "Debe rellenar usuario\n"
        }
        if pass.isEmpty {
            mensaje += "Debe rellenar password\n"
        }
        if usuario.count < 6 || pass.count < 6 {
            mensaje += "Usuario y contraseña deben tener al menos 6 caracteres"
        }
        
        if mensaje != "" {
            mostrarAlert(mensaje: mensaje)
            print("")
        } else {
            downloadData(userText: TextFieldUser.text!, passText: TextFieldPass.text!)
        }
        
    }
    
    func mostrarAlert(mensaje : String){
        let alert = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        
        let cerrarAction = UIAlertAction(title: "Salir", style: .destructive, handler: nil)
        
        alert.addAction(cerrarAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    
    
    // Método para pasar informmación entre StoryBoard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_pantalla_saludo"{
            let vc = segue.destination as! VC_Pantalla_Usuario
            vc.nombre = TextFieldUser.text ?? ""
        }
    }
    
    // Método para comprobar antes de realizar un segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "to_pantalla_saludo"{
            if let texto = TextFieldUser.text, texto != ""{
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func downloadData(userText : String, passText : String){
        //Peticion por el metodo GET
        
        let urlString = "https://qastusoft.com.es/apis/login.php?user=\(userText)&pass=\(passText)"
        // user , pass
        
        guard let url = URL(string : urlString) else {return }
        
        URLSession.shared.dataTask(with: url){(data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                print("El status code es \(httpStatus.statusCode)")
                print("response =  \(response)")
            }
            guard let data = data else { return }
                        
            //Decodificar y parsear JSON
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [String:Any]
                
                print(json)
                
                let respuesta = json["code"] as! Int
                
                DispatchQueue.main.sync {
                    if self.displayData(datos: respuesta) == false{
                        print(self.displayData(datos: respuesta))
                        let mensaje = "Por favor, introduzca un usuario y una contraseña correcta"
                        self.mostrarAlert(mensaje: mensaje)
                        print("llega aqui")
                    }else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "Pantalla_Usuario") as! VC_Pantalla_Usuario
                        vc.nombre = self.TextFieldUser.text ?? ""
                        
                        // Presentamos el nuevo VC
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }
                
            } catch let jsonError{
                print(jsonError)
            }
            
        }.resume()
    }
    
    func displayData(datos : Int)-> Bool {
        if datos > 0 {
            return true
        }else {
            return false
            
        }
    }
    
}



