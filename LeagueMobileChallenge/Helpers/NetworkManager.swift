
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire
class NetworkManager {

//shared instance
static let shared = NetworkManager()

let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

func startNetworkReachabilityObserver() {

    reachabilityManager?.listener = { status in
        switch status {

            case .notReachable:
                APPDELEGATE?.window?.rootViewController?.showToast(message: AlertMessage.msgNotReachable)
            case .unknown :
                APPDELEGATE?.window?.rootViewController?.showToast(message: AlertMessage.msgUnknown)

            case .reachable(.ethernetOrWiFi):
                print("Internet is reachable")

            case .reachable(.wwan):
                APPDELEGATE?.window?.rootViewController?.showToast(message: AlertMessage.msgWWAN)
            }
        }

        // start listening
        reachabilityManager?.startListening()
   }
}
