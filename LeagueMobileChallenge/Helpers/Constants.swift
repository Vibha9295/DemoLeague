
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

let USERDEFAULTS = UserDefaults.standard
let APPDELEGATE = UIApplication.shared.delegate as? AppDelegate

enum UserDefaultsKeys: String {
    case accessToken // access token
    
}
struct WebServiceURLs {
    static let domain = "https://engineering.league.dev/challenge/api/"
    static let loginAPI = domain + "login"
    static let userAPI = domain + "users"
    static let postsAPI = domain + "posts"
}
struct AlertMessage{
    static let msgWWAN = "WWAN is reachable"
    static let msgUnknown = "Unknown Internet is reachable"
    static let msgNotReachable = "Internet is not reachable"
}
struct CellID{
    static let cellPostTbl = "PostTblCell"
}
