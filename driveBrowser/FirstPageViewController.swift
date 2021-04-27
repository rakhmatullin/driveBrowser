//
//  FirstPageViewController.swift
//  driveBrowser
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class FirstPageViewController: UIViewController {
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var fileInfoLabel: UILabel!
    
    var service = GTLRDriveService()
    var email: String = ""
    
    var isAuthorized: Bool! {
        didSet {
            if !isAuthorized {
                mainButton.setTitle("Войти", for: .normal)
            } else {
                mainButton.setTitle("Показать список файлов", for: .normal)
            }
        }
    }
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        if isAuthorized {
            let vc = DriveBrowserViewController()
            vc.delegate = self
            vc.setupService(service, email: email)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            setupGoogleSignIn()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAuthorized = false
        setupInfoLabel(with: "")
    }
    
    private func setupInfoLabel(with text: String) {
        fileInfoLabel.numberOfLines = 0
        fileInfoLabel.text = text
    }
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveReadonly]
        GIDSignIn.sharedInstance().signIn()
    }

}

extension FirstPageViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            isAuthorized = false
            service.authorizer = nil
            
            dismiss(animated: true, completion: nil)
            debugPrint("\(error.localizedDescription)")
        } else {
            isAuthorized = true
            email = user.profile.email
            service.authorizer = user.authentication.fetcherAuthorizer()
            
            debugPrint(user.profile.name ?? "")
            debugPrint(user.profile.email ?? "")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        print("Dismiss GoogleSignIn")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
}

extension FirstPageViewController: FirstPageViewControllerDelegate {
    func pickedFile(file: GTLRDrive_File) {
        setLabel(data: file)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLabel(data: GTLRDrive_File) {
        var fileSize = ""
        if let size = data.size as? Int {
            if size > 1073741824 {
                fileSize = String.localizedStringWithFormat("%.1fGB", Double(size / 1073741824))
            } else if size > 1048576 {
                fileSize = String.localizedStringWithFormat("%.1fMB", Double(size / 1048576))
            } else {
                fileSize = String.localizedStringWithFormat("%.1fKB", Double(size / 1024))
            }
        }
        fileInfoLabel.text = data.name! + "\n" + fileSize
        fileInfoLabel.sizeToFit()
    }
    
}
