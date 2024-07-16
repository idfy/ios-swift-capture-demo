//
//  SecondViewController.swift
//  ViewNavigation
//
//  Created by Admin on 12/07/22.
//

import UIKit
import SafariServices
import AVFoundation
import CoreLocation

class ViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate  {
    
    @IBOutlet var urlTextField: UITextField!
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlTextField.delegate = self
        
    }

    @IBAction func openWebVC(_sender : UIButton){
        requestPermissions{
            guard let link = self.urlTextField.text else { return }
            let viewController = (self.storyboard?.instantiateViewController(withIdentifier:"WkWebViewController") as? WkWebViewController)!
            viewController.url = link
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
    
    func requestPermissions(completion: @escaping () -> Void) {
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            let microphoneStatus = AVAudioSession.sharedInstance().recordPermission
            let locationStatus = CLLocationManager.authorizationStatus()
            
            let dispatchGroup = DispatchGroup()
            
            if cameraStatus == .notDetermined {
                dispatchGroup.enter()
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    dispatchGroup.leave()
                }
            }
            
            if microphoneStatus == .undetermined {
                dispatchGroup.enter()
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    dispatchGroup.leave()
                }
            }
            
            if locationStatus == .notDetermined {
                dispatchGroup.enter()
                self.locationManager.requestWhenInUseAuthorization()
                DispatchQueue.main.async {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if AVCaptureDevice.authorizationStatus(for: .video) == .authorized &&
                   AVAudioSession.sharedInstance().recordPermission == .granted &&
                   CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                    completion()
                } else {
                    // Handle lack of permissions
                    let alert = UIAlertController(title: "Permissions Required", message: "Please grant camera, microphone, and location permissions to proceed.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        // CLLocationManagerDelegate method
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                // Location access granted
            }
        }
}
