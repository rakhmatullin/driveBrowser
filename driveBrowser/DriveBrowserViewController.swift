//
//  DriveBrowserViewController.swift
//  driveBrowser
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

protocol DriveBrowserViewDelegate {
    func onPressFile(file: GTLRDrive_File)
    func needReload()
}

class DriveBrowserViewController: UIViewController {
    var delegate: FirstPageViewControllerDelegate?
    var service: GTLRDriveService!
    var drive: DriveApi?
    var mainView: ObserverView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = ObserverView(frame: self.view.frame)
        mainView.delegate = self
        view.addSubview(mainView)
        
        let mask = UIImage()
        navigationController?.navigationBar.backIndicatorImage = mask
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = mask
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    
    func setupService(_ service: GTLRDriveService, email: String) {
        self.service = service
        setupNavigationTitle(with: email)
    }
    
    private func setupNavigationTitle(with email: String) {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        let firstFont = UIFont.systemFont(ofSize: 13)
        let secondFont = UIFont.boldSystemFont(ofSize: 17)
        let firstAttributes: [NSAttributedString.Key: Any] = [.font: firstFont,
                                                              .foregroundColor: UIColor.gray]
        let secondAttributes: [NSAttributedString.Key: Any] = [.font: secondFont,
                                                                .foregroundColor: UIColor.black]

        let firstString = NSMutableAttributedString(string: email + "\n", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Google Drive", attributes: secondAttributes)

        firstString.append(secondString)
        label.attributedText = firstString
        navigationItem.titleView = label
    }
    
    
    fileprivate func loadData() {
        drive = DriveApi(service)
        
        drive?.listFilesInMyDrive(onCompleted: { (list, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let list = list {
                self.mainView.reloadTableView(list)
            }
        })
    }
    
}

extension DriveBrowserViewController: DriveBrowserViewDelegate {
    func onPressFile(file: GTLRDrive_File) {
        if file.isFolder() {
            return
        }
        delegate?.pickedFile(file: file)
    }
    
    func needReload() {
        loadData()
    }
}
