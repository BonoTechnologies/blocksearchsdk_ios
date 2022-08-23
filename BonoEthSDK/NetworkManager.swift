//
//  NetworkManager.swift
//  CoinUs
//
//  Created by KangMinSoo on 2017. 12. 3..
//  Copyright © 2017년 CoinUs. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

struct Constants {
    
    static let keyAuthToken = "authToken";
    static let keyUDID = "appUDID";
    
}
class NetworkManager {
    
    private init() {}
    static let shared = NetworkManager()
    
    // MARK: - Properties
    var baseURL: String {
        get{
            
            //개발
            return "https://dev-apis.coinus.io/v2"
            //라이브
//            return "https://apis.coinus.io/v2"
        }
    }
    
    let apiKey = "rkwsclm40ew51iv3uhs6ef2nkvbk6424"
    
    var appUDID: String{
        set(newVal){
            UserDefaults.standard.set(newVal,
                                      forKey: Constants.keyUDID)
            UserDefaults.standard.synchronize()
        }
        get{
            if let udid = UserDefaults.standard.string(forKey: Constants.keyUDID){
                return udid
            }else{
                if let udid = UIDevice.current.identifierForVendor?.uuidString{
                    UserDefaults.standard.set(udid,
                                              forKey: Constants.keyUDID)
                    UserDefaults.standard.synchronize()
                    return udid
                }
                return ""
            }
        }
    }
    
    var mnemonic: String = ""
    
    // MARK: - Header
    
    func getHeader(url: String,
                   method: HTTPMethod,
                   authToken: String? = nil,
                   isNoLogin: Bool = false,
                   timeout: TimeInterval = 30,
                   isLog: Bool = false,
                   parameters: JSON?)->DataRequest{
        
        var headers = HTTPHeaders(["Content-Type" : "application/json",
                                   "Api-Key" : self.apiKey,
                                   "App-Device-Udid" : self.appUDID,
                                   "App-Version": "3.0.1",
                                   "App-Language" : "en",
                                   "App-Device-Currency": "USD",
                                   "device-model": UIDevice.current.model])
        
        
        if let token = authToken{
            headers.add(name: "Auth-Token", value: token)
        }else if let token = UserDefaults.standard.string(forKey: Constants.keyAuthToken){
            headers.add(name: "Auth-Token", value: token)
        }
        
        switch method{
        
        case .get:
            
            return AF.request(url,
                              method: method,
                              parameters: parameters,
                              encoder: URLEncodedFormParameterEncoder.default,
                              headers: headers){
                urlRequest in
                urlRequest.timeoutInterval = timeout
            }
            
        default:
            
            return AF.request(url,
                              method: method,
                              parameters: parameters,
                              encoder: JSONParameterEncoder.default,
                              headers: headers){
                urlRequest in
                urlRequest.timeoutInterval = timeout
            }

        }
    }
    
    // MARK: - Intro
    //부트API
    func getBootingCoinUsApp(deviceToken: String,
                             block:@escaping (JSON,Error?) -> Void){
        
        let str_url = "\(self.baseURL)/booting/coins-us-app"
        
        let params = JSON(["deviceToken" : deviceToken,
                           "deviceModel" : UIDevice.current.model,
                           "mobileOsVersion" : UIDevice.current.systemVersion,
                           "deviceVendor" : "Apple"])
        
        NetworkManager.shared.getHeader(url: str_url,
                                        method: .get,
                                        parameters: params)
            .validate()
            .responseJSON(completionHandler: {
                response in
                
                switch response.result {
                case .success:
                    let result = JSON(response.data)
                    block(result, nil)
                case let .failure(error):
                    block(JSON(), error)
                }
            })
    }
    
    // MARK: - User
    
    //유저 등록
    func insertUser(userSeed: String,
                    backupYn: String,
                    restoreYn: String,
                    block:@escaping (JSON,Error?) -> Void){
        
        let str_url = "\(self.baseURL)/users"
        
        let param = JSON(["userSeed" : userSeed,
                          "backupYn" : backupYn,
                          "restoreYn" : restoreYn,
                          "languageCd" : "en",
                          "currencyCd": "USD"])
        
        
        NetworkManager.shared.getHeader(url: str_url,
                                        method: .post,
                                        parameters: param)
            .validate()
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    let result = JSON(response.data)
                    block(result, nil)
                case let .failure(error):
                    block(JSON(), error)
                }
                
            })
    }
    
    //지갑정보 목록 조회
    func getWalletList(block:@escaping (JSON,Error?) -> Void){
        
        let str_url = "\(self.baseURL)/wallets"
        
        let params = JSON(["pageNo" : 1,
                           "pageSize" : 10])
       
        
        NetworkManager.shared.getHeader(url: str_url,
                                        method: .get,
                                        parameters: params).validate().responseJSON(completionHandler: {
                                            response in
                                            
                                            switch response.result {
                                            case .success:
                                                let result = JSON(response.data)
                                                block(result, nil)
                                                break;
                                            case let .failure(error):
                                                block(JSON(), error)
                                                break;
                                            }
                                        })
    }
    
    func insertWallet(walletAddress: String,
                      block:@escaping (JSON,Error?) -> Void){
        
        let str_url = "\(self.baseURL)/wallets"
        
        let param = JSON(["coinId" : 10001,
                          "walletAddress" : walletAddress,
                          "walletAddressIndex" : 0,
                          "walletAddressNm" : "Wallet"])
        
        NetworkManager.shared.getHeader(url: str_url,
                                        method: .post,
                                        parameters: param)
            .validate()
            .responseJSON(completionHandler: {
                response in
                switch response.result {
                case .success:
                    let result = JSON(response.data)
                    block(result, nil)
                    break;
                    
                case let .failure(error):
                    block(JSON(), error)
                    break;
                    
                }
            })
    }
    
}
