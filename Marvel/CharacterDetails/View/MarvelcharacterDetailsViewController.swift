//
//  MarvelcharacterDetailsViewController.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import UIKit

class MarvelcharacterDetailsViewController: UIViewController {
        
    var characterDataReceive:CharacterModel?
    var viewModel = CharacterDetailsViewModel()
    var alertView = AlertView()
    var indicator:UIActivityIndicatorView?
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Items]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        setActivityIndicator()
        tableViewConfigure()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = characterDataReceive?.name
        self.navigationController?.navigationBar.prefersLargeTitles = false
        loadCharacterDetails()
    }
    
    func tableViewConfigure() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadCharacterDetails() {
        indicator?.startAnimating()
        if NetworkManager().isConnectedToNetwork() {
            let timeStamp = Date().generateTimeStamp()
            let hash = String().generateMd5HashValue(timestamp:timeStamp)
            let request = CharacterRequest(hash:hash,ts:timeStamp, limit: nil)
            viewModel.fetchMarvelCharacterDetails(marvelCharacterRequest:request,characterId:characterDataReceive?.id ?? 0)
        }
        else {
            indicator?.stopAnimating()
            //AlertView().showAlertView(alertTitle:"Alert", alertMsg:"No Internet Connection", view:self)
            AlertView().showAlertViewWithReload(view:self)
        }
    }
    
    func configureDelegates() {
        viewModel.delegate = self
        alertView.delegate = self
    }
    
    func setActivityIndicator() {
        indicator = ActivityIndicatorView.customIndicator(at:self.view.center)
        self.view.addSubview(indicator!)
    }
}

extension MarvelcharacterDetailsViewController:CharacterDetailsViewModelDelegate {
    
    func didReceiveCharacterDetails(dataResponse:CharacterModel?) {
        indicator?.stopAnimating()
        if let characterDetailResponse = dataResponse {
            setValues(characterDet:characterDetailResponse)
        }
    }
    
    func didFailWithError(msg:String) {
        indicator?.stopAnimating()
        AlertView().showAlertView(alertTitle:"Alert", alertMsg:msg, view:self)
    }
    
    func setValues(characterDet:CharacterModel) {
        
        let headerView = CharacterDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 300))
        headerView.nameCharacter.text = characterDet.name
        if characterDet.description != "" {
            headerView.descCharacter.text = characterDet.description
        } else {
            headerView.descCharacter.text = "Description not available"
        }
        
        let imageUrl = URL(string:(characterDet.thumbnail.path + "." + characterDet.thumbnail.imageExtension))
        if let imageUrl = imageUrl {
            headerView.imgCharacter.kf.setImage(with: imageUrl)
        }
        
        headerView.btnLike.setImage(UIImage(named: "favorite"), for: .normal)
        headerView.btnLike.isHidden = false
        
        if let data = UserDefaults.standard.data(forKey: "favorited") {
            do {
                let decoder = JSONDecoder()
                let favoritedData = try decoder.decode([CharacterModel].self, from: data)
                
                if favoritedData.contains(where: {$0.id == characterDet.id}) {
                    headerView.btnLike.setImage(UIImage(named: "selectedFavorite"), for: .normal)
                } else {
                    headerView.btnLike.setImage(UIImage(named: "favorite"), for: .normal)
                }
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        headerView.likeClicked = {
            var data = self.getData()

            if headerView.btnLike.currentImage == UIImage(named: "selectedFavorite") {
                if data.contains(where: {$0.id == characterDet.id}) {
                    data.removeAll(where: {$0.id == characterDet.id})
                    self.setData(data: data)
                    headerView.btnLike.setImage(UIImage(named: "favorite"), for: .normal)
                } else {
                    data.append(characterDet)
                    self.setData(data: data)
                    headerView.btnLike.setImage(UIImage(named: "selectedFavorite"), for: .normal)
                }
            } else {
                data.append(characterDet)
                self.setData(data: data)
                headerView.btnLike.setImage(UIImage(named: "selectedFavorite"), for: .normal)
            }
        }
        
        tableView.tableHeaderView = headerView
        self.characterDataReceive = characterDet
        self.items = self.characterDataReceive?.comics.items.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending}
    }
}

extension MarvelcharacterDetailsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "COMICS"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.items?[indexPath.row].name
        return cell
    }
}

extension MarvelcharacterDetailsViewController:AlertDelegate {
    
    func tryAgain(controller: UIViewController) {
        loadCharacterDetails()
    }
}

extension MarvelcharacterDetailsViewController: StoryboardInstantiable {
    
    static var storyboardName: String { return "CharacterDetails" }
    static var storyboardIdentifier: String? { return "MarvelcharacterDetailsViewController" }
}

extension MarvelcharacterDetailsViewController {
    
    // Cache
    func getData()-> [CharacterModel] {
        var favoritedDatam = [CharacterModel]()
        if let data = UserDefaults.standard.data(forKey: "favorited") {
            do {
                let decoder = JSONDecoder()
                let favoritedData = try decoder.decode([CharacterModel].self, from: data)
                favoritedDatam = favoritedData
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return favoritedDatam
    }
    
    func setData(data: [CharacterModel]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            UserDefaults.standard.set(data, forKey: "favorited")
        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
}
