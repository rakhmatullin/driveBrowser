//
//  ObserverView.swift
//  driveBrowser
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit
import GoogleAPIClientForREST

protocol DriveBrowserViewDelegate {
    func onPressBack()
    func onPressSignOut()
    func onPressPrevDir()
    func onPressFile(file: GTLRDrive_File)
    func onPressMyDrive()
    func onPressShared()
}

class ObserverView: UIView {
    var delegate: DriveBrowserViewDelegate?
    var tableView: UITableView!
    var loadingView: UIActivityIndicatorView!
    var inRoot = true // Use to check if in the root path of Google Drive
    var items = [GTLRDrive_File]() {
        didSet {
            items = items.sorted(by: DriveApi.sortFiles)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    private func viewInit() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FileCell.self, forCellReuseIdentifier: "MyCell")
        
        tableView.pin(to: self)
        tableView.rowHeight = 60
        //tableView.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        
    }
    
    public func reloadTableView(_ files: [GTLRDrive_File], inRoot: Bool = true) {
        items = files
        self.inRoot = inRoot
        tableView.reloadData()
        //let cells = tableView.visibleCells
        /*for cell in cells {
            cell.alpha = 0
        }
        for cell in cells {
            UIView.animate(withDuration: 0.5) {
                cell.alpha = 1
            }
        }*/
    }
    
    public func setLoading(_ loading: Bool) {
        if loading {
            //loadingView.startAnimating()
        } else {
            //loadingView.stopAnimating()
        }
    }

}


extension ObserverView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FileCell
        cell.setData(data: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onPressFile(file: items[indexPath.row])
    }
}

