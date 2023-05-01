
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import UIKit

class PostVC: UIViewController {
    
    //MARK: -  Outlets
    @IBOutlet weak var tblUsers: UITableView!
    
    //MARK: - Variable Declaration
    lazy var userVCModel = {
        PostVCViewModel()
    }()
    
    //MARK: - ViewController Method
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Initialization Method
    
    func initView() {
        tblUsers.register(PostTblCell.nib, forCellReuseIdentifier: PostTblCell.identifier)
        tblUsers.tableFooterView = UIView()
        tblUsers.separatorStyle = .none
        tblUsers.allowsSelection = false
    }
    
    func initViewModel() {
        userVCModel.getUsersData()
        // Reload TableView closure
        userVCModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tblUsers.reloadData()
            }
        }
    }
}

//MARK: - Post Delegate Extension

extension PostVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userVCModel.userCellViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.cellPostTbl, for: indexPath) as? PostTblCell else { fatalError("xib does not exists") }
        let cellVM = userVCModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}

