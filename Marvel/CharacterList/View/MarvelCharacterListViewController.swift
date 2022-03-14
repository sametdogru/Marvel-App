//
//  MarvelCharacterListViewController.swift
//  Marvel
//
//  Created by Samet Doğru on 14.02.2022.
//

import UIKit

class MarvelCharacterListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnNextHeightConstant: NSLayoutConstraint!
    
    var viewModel = CharacterViewModel()
    var alertView = AlertView()
    
    var characterDataArray:[CharacterModel]?
    var indicator:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        tableViewConfigure()
        configureDelegates()
        setActivityIndicator()
        loadCharacterList()
    }
    
    func tableViewConfigure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseTableViewCell.self)
    }
    
    func loadCharacterList() {
        indicator?.startAnimating()
        if NetworkManager().isConnectedToNetwork() {
            let timeStamp = Date().generateTimeStamp()
            let hash = String().generateMd5HashValue(timestamp:timeStamp)
            let request = CharacterRequest(hash:hash,ts:timeStamp, limit: 30)
            viewModel.fetchMarvelCharacters(marvelCharacterRequest:request)
        }
        else {
            indicator?.stopAnimating()
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
    
    @IBAction func nextClicked(_ sender: UIButton) {
        indicator?.startAnimating()
        let timeStamp = Date().generateTimeStamp()
        let hash = String().generateMd5HashValue(timestamp:timeStamp)
        let request = CharacterRequest(hash:hash,ts:timeStamp, limit: (characterDataArray?.count ?? 0) + 30)
        viewModel.fetchMarvelCharacters(marvelCharacterRequest:request)
    }
    
    private func btnTransition(item: UIView, constant: CGFloat) {
        UIView.transition(with: item, duration: 0.5, options: .curveEaseInOut, animations: {
            self.btnNextHeightConstant.constant = constant
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension MarvelCharacterListViewController:AlertDelegate {
    
    func tryAgain(controller: UIViewController) {
        loadCharacterList()
    }
}

extension MarvelCharacterListViewController:CharacterViewModelDelegate {
    
    func didReceiveResponse(dataResponse:[CharacterModel]?) {
        indicator?.stopAnimating()
        guard let dataResponse = dataResponse else { return }
        if (characterDataArray?.count ?? 0) >= 30 {
            characterDataArray?.append(contentsOf: dataResponse)
        } else {
            characterDataArray = dataResponse
        }
        tableView.reloadData()
    }
    
    func didFailWithError(msg:String) {
        indicator?.stopAnimating()
        AlertView().showAlertView(alertTitle:"Alert", alertMsg:msg, view:self)
    }
}

extension MarvelCharacterListViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:CellIdentifiers.characterCell) as! BaseTableViewCell
        let character = self.characterDataArray?[indexPath.row]
        if let localCharacter = character {
            cell.cellConfigure(character:localCharacter)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        let characterDetail = self.characterDataArray?[indexPath.row]
        let vc = MarvelcharacterDetailsViewController.instantiate()
        vc.characterDataReceive = characterDetail
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (characterDataArray?.count ?? 0) - 1 {
            btnTransition(item: self.btnNext, constant: 30)
            btnNext.isHidden = false
        } else {
            btnTransition(item: self.btnNext, constant: 0)
            btnNext.isHidden = true
        }
    }
}


// MARK : - StoryboardInstantiable
extension MarvelCharacterListViewController: StoryboardInstantiable {
    
    static var storyboardName: String { return "CharacterList" }
    static var storyboardIdentifier: String? { return "MarvelCharacterListViewController" }
}
