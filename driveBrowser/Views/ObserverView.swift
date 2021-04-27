//
//  ObserverView.swift
//  driveBrowser
//
//  Created by Ренат Рахматуллин on 26.04.2021.
//

import UIKit
import GoogleAPIClientForREST

class ObserverView: UIView {
    var delegate: DriveBrowserViewDelegate?
    var tableView: UITableView!
    let refreshControl = UIRefreshControl()
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
        tableView.register(FileCell.self, forCellReuseIdentifier: FileCell.identifier)
        
        tableView.pin(to: self)
        tableView.rowHeight = 60
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(updateTableViewContent), for: .valueChanged)
    }
    
    @objc private func updateTableViewContent() {
        delegate?.needReload()
        refreshControl.endRefreshing()
    }
    
    public func reloadTableView(_ files: [GTLRDrive_File]) {
        items = files
        tableView.reloadData()
    }
}


extension ObserverView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileCell.identifier) as! FileCell
        cell.setData(data: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onPressFile(file: items[indexPath.row])
    }
}

