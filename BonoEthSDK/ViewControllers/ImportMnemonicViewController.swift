//
//  ViewController.swift
//  BonoEthSDK
//
//  Created by MinSoo Kang on 2022/08/23.
//

import UIKit

import SwiftyJSON
import CryptoSwift

class ImportMnemonicViewController: UIViewController {

    
    @IBOutlet weak var tv_mnemonic: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tv_mnemonic.text = "grass radio cattle income glove thrive attract miracle cheap course tray torch"
        NetworkManager.shared.getBootingCoinUsApp(deviceToken: "") {
            result, error in
            print("getBootingCoinUsApp result : \(result)")
            print("getBootingCoinUsApp error : \(error)")
        }
        
    }

    @IBAction func clickRegister(_ sender: Any) {
        
        
        if let mnemonic = self.tv_mnemonic.text{
            
            let seed = mnemonic.sha256()
            NetworkManager.shared.insertUser(userSeed: seed, backupYn: "N", restoreYn: "Y", block: {
                [weak self] result, error in
                
                print("insertUser result : \(result)")
                print("insertUser error : \(error)")
                
                if result["status"]["code"].intValue == 200,
                   result["data"]["result"]["isSuccess"].boolValue == true,
                   let authToken = result["data"]["authToken"].string{
                    
                    NetworkManager.shared.mnemonic = mnemonic
                    
                    UserDefaults.standard.set(authToken,
                                              forKey: Constants.keyAuthToken)
                    UserDefaults.standard.synchronize()
                    
                    
                    
                    
                    self?.showAPIListViewController()
                }
                
            })
        }
    }
    
    private func showAPIListViewController(){
        
        let board = UIStoryboard(name: "Main",
                                 bundle: Bundle.main);
        
        let vc_api = board.instantiateViewController(withIdentifier: "APIListViewController") as! APIListViewController
        
        self.present(vc_api,
                     animated: true,
                     completion: nil)
    }
    
}

