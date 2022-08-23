//
//  APIListViewController.swift
//  BonoEthSDK
//
//  Created by MinSoo Kang on 2022/08/23.
//

import UIKit
import SwiftyJSON

class APIListViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mnemonic = NetworkManager.shared.mnemonic
        let authToken =  UserDefaults.standard.string(forKey: Constants.keyAuthToken)
        
        print("mnemonic : \(mnemonic)")
        print("authToken : \(authToken)")
        
        NetworkManager.shared.getWalletList {
            [weak self] result, error in
            print("getWalletList : \(result)")
            
            if result["data"]["items"].count == 0 {
                self?.addWallet()
            }else{
                self?.showWallet()
            }
        }
    }
    
    private func addWallet(){
        
        
    }
    
    private func showWallet(){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
