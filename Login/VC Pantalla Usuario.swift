//
//  VC Pantalla Usuario.swift

//

import UIKit

class VC_Pantalla_Usuario: UIViewController {

    @IBOutlet weak var LabelNombre: UILabel!
    
    var nombre = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelNombre.text = nombre
        // Do any additional setup after loading the view.
    }
    

}
