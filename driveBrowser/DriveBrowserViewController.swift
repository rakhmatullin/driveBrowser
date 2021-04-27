//
//  ViewController.swift
//  driveBrowser
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

protocol FirstPageViewControllerDelegate {
    func pickedFile(file: GTLRDrive_File)
}

class DriveBrowserViewController: UIViewController {
    
    var delegate: FirstPageViewControllerDelegate?
    var service: GTLRDriveService!
    var drive: DriveApi?
    var mainView: ObserverView!
    var onFinish: ((_ data: [String: Any]?, _ error: String?) -> Void)?
    var mimeTypes = [String]()
    var didOpenSignIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = ObserverView(frame: self.view.frame)
        mainView.delegate = self
        view.addSubview(mainView)
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
        for type in mimeTypes {
            drive?.mimeTypes.append(contentsOf: Utils.convertFileTypeToMimeType(type))
        }
        
        drive?.listFilesInMyDrive(onCompleted: { (list, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let list = list {
                self.mainView.reloadTableView(list, inRoot: true)
            }
        })
    }
    
}

extension DriveBrowserViewController: DriveBrowserViewDelegate {
    
    func onPressFile(file: GTLRDrive_File) {
        if file.isFolder() {
            /*guard let id = file.identifier else { return }
            currentPath.append(id)
            loadData()*/
            return
        }
        guard let id = file.identifier, let name = file.name, let size = file.size as? Int else {
            //self.onFinish?(nil, "Failed to choose file from Google Drive")
            //self.dismiss(animated: true, completion: nil)
            return
        }
        /*let dictionary = [
            "id": id,
            "name": name,
            "size": size,
            "mimeType": "application/pdf",
            "service": "google",
            "remoteEmail": service.authorizer?.userEmail ?? ""
            ] as [String : Any]*/
        //onFinish?(dictionary, nil)
        delegate?.pickedFile(file: file)
    }
    
}
