//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
class APIController {
    
    static let shared = APIController()
    fileprivate var userToken: String?
    func request(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        guard let userToken = userToken else {
            print("No user token set")
            completion(nil, nil)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
            completion(response.data, response.error)
        }
    }
}

protocol APIControllerProtocol {
    func fetchUserToken(userName: String,password: String,completion: @escaping (String?, Error?) -> ())
    func fetchUsers(completion: @escaping (_ success: Bool, _ results: Users?, _ error: String?) -> ())
    func fetchPosts(completion: @escaping (_ success: Bool, _ results: Posts?, _ error: String?) -> ())
}

class UserService: APIControllerProtocol {
    
    fileprivate var userToken: String?
    
    //MARK: - Fetch Token API
    
    func fetchUserToken(userName: String = "", password: String = "",completion: @escaping (String?, Error?) -> ()) {
        guard let url = URL(string: WebServiceURLs.loginAPI) else {
            return
        }
        if Connectivity.isConnectedToInternet{
            var headers: HTTPHeaders = [:]
            
            if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            Alamofire.request(url, headers: headers).responseJSON { (response) in
                guard response.error == nil else {
                    completion(nil, response.error)
                    return
                }
                
                if let value = response.result.value as? [AnyHashable : Any] {
                    self.userToken = value["api_key"] as? String
                }
                completion(self.userToken, nil)
            }
        }
    }
    
    //MARK: - Fetch Users API
    
    func fetchUsers(completion: @escaping (Bool, Users?, String?) -> ()) {
        
        var authHeader: HTTPHeaders = ["x-access-token" : ""]
        if isKeyPresentInUserDefaults(key: UserDefaultsKeys.accessToken.rawValue){
            authHeader = ["x-access-token" : (USERDEFAULTS.getDataForKey(.accessToken) as! String)]
            
        }
        guard USERDEFAULTS.getDataForKey(.accessToken) as? String != nil else {
            print("No user token set")
            completion(false, nil, nil)
            return
        }
        
        Alamofire.request(WebServiceURLs.userAPI, method: .get, encoding: URLEncoding.default, headers: authHeader)
            .validate(statusCode: 200..<300)
            .responseData { response in // note the change to responseData
                switch response.result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(Users.self, from: data)
                        print(result)
                        completion(true, result, nil)
                    } catch {
                        completion(false, nil, "Error: Trying to parse Users to model")
                        print(error) }
                }
            }
        
    }
    
    //MARK: - Fetch Posts API
    
    func fetchPosts(completion: @escaping (Bool, Posts?, String?) -> ()) {
        
        var authHeader: HTTPHeaders = ["x-access-token" : ""]
        if isKeyPresentInUserDefaults(key: UserDefaultsKeys.accessToken.rawValue){
            authHeader = ["x-access-token" : (USERDEFAULTS.getDataForKey(.accessToken) as! String)]
            
        }
        guard USERDEFAULTS.getDataForKey(.accessToken)  as? String != nil  else {
            print("No user token set")
            completion(false, nil, nil)
            return
        }
        Alamofire.request(WebServiceURLs.postsAPI, method: .get, encoding: URLEncoding.default, headers: authHeader)
            .validate(statusCode: 200..<300)
            .responseData { response in // note the change to responseData
                switch response.result {
                case .failure(let error):
                    print(error)
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(Posts.self, from: data)
                        print(result)
                        completion(true, result, nil)
                    } catch {
                        completion(false, nil, "Error: Trying to parse Posts to model")
                        print(error) }
                }
            }
    }
    
}
