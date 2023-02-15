//
//  SecondViewController.swift
//  ViewNavigation
//
//  Created by Admin on 12/07/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var urlTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlTextField.delegate = self
        
    }

    @IBAction func openWebVC(_sender : UIButton){
        guard let link = urlTextField.text else { return }
        let viewController = (self.storyboard?.instantiateViewController(withIdentifier:"WkWebViewController") as? WkWebViewController)!
        viewController.url = link
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func openSafariVC(_sender : UIButton) {
        guard let link = urlTextField.text else { return }
        guard let url = URL(string: link) else { return }
        present(SFSafariViewController(url: url), animated: true, completion:  nil)
    }

    @IBAction func openSafariApp(_sender : UIButton) {
        guard let link = urlTextField.text else { return }
        if let urlToOpen = URL(string: link) {
            UIApplication.shared.open(urlToOpen)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
