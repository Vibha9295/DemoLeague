
//  Copyright © 2023 Kelvin Lau. All rights reserved.
//

import Foundation
extension UserDefaults {
    // MARK: user default
    func removeDataForKey(_ key: UserDefaultsKeys) {
        self.removeObject(forKey: key.rawValue)
    }
    
    func setDataForKey(_ data: Any, _ key: UserDefaultsKeys) {
        self.set(data, forKey: key.rawValue)
    }
    
    func getDataForKey( _ key: UserDefaultsKeys) -> AnyObject {
        return object(forKey: key.rawValue) as AnyObject
    }
    
    func getDoubleForKey( _ key: UserDefaultsKeys) -> Double {
        return double(forKey: key.rawValue)
    }
    func getIntegerForKey( _ key: UserDefaultsKeys) -> Int {
        return Int(key.rawValue)!
    }
}
