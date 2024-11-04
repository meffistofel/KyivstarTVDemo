//
//  Configuration.swift
//  DemoApp
//
//  Created by Alex Kovalov on 10/30/24.
//

import Foundation

final class AppConfiguration {

    // MARK: - Properties

    private let config: NSDictionary
    private let environment: WebEnvironment = AppEnvironment.current == .production ? .prod : .dev

    // MARK: - Init

    init(dictionary: NSDictionary) {
        config = dictionary
    }

    convenience init() {
        let bundle = Bundle.main
        let configPath = bundle.path(forResource: "Configuration", ofType: "plist")!
        let config = NSDictionary(contentsOfFile: configPath)!

        let dict = NSMutableDictionary()
        if let configs = config[Bundle.main.infoDictionary?["Configuration"] ?? ""] as? [AnyHashable: Any] {
            dict.addEntries(from: configs)
        }

        self.init(dictionary: dict)
    }
}

extension AppConfiguration {
    enum WebEnvironment {
        case dev
        case prod
    }

    var apiURL: String {
        config["apiURL"] as! String
    }
}


enum AppEnvironment {
    case develop
    case stage
    case production

    #if DEBUG
    static let current: AppEnvironment = .develop
    #else
    static let current: AppEnvironment = .production
    #endif

    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    var appId: String {
        let baseURLString: String = {
            switch self {
            case .develop: return ""
            case .stage: return ""
            case .production: return "1597753705"
            }
        }()
        return baseURLString
    }

    func getCurrent() -> AppEnvironment {
        #if DEBUG
        return .develop
        #else
        return .production
        #endif
    }
}
