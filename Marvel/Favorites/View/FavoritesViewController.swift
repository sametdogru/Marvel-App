//
//  FavoritesViewController.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = FavoritesViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getFavoritedGames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        title = "Favorites"
        tableViewViewConfigure()
    }
    
    func getFavoritedGames() {
        self.viewModel.getFavoritedGames()
        
        self.viewModel.updateUI = {
            self.tableView.reloadData()
        }
        
        self.viewModel.updateUIWithError = { error in
            //            self.showAlert(error)
        }
    }
    
    func tableViewViewConfigure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseTableViewCell.self)
    }
}


extension FavoritesViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel.getItemsCount() == 0 {
            self.tableView.setEmpty(message: "Henüz favorilere karakter eklemediniz!")
        } else {
            self.tableView.restore()
        }
        return self.viewModel.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:CellIdentifiers.characterCell) as! BaseTableViewCell
 
        let item = self.viewModel.getItemAtIndex(indexPath.row)
        cell.cellConfigure(character:item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        let characterDetail = self.viewModel.getItemAtIndex(indexPath.row)
        let vc = MarvelcharacterDetailsViewController.instantiate()
        vc.characterDataReceive = characterDetail
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
