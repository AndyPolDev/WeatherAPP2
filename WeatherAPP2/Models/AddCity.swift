import Foundation
import UIKit

extension UIViewController {
    func alertAddCity(name: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        
        let alertAddButton = UIAlertAction(title: "OK", style: .default) { (action) in
            let text = alertController.textFields?.first?.text
            guard let safeText = text else { return }
            completionHandler(safeText)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.autocapitalizationType = .words
        }
        
        let alertCancalButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(alertAddButton)
        alertController.addAction(alertCancalButton)
        
        present(alertController, animated: true, completion: nil)
    }
}
