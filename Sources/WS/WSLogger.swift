//
//  WSLogger.swift
//  WS
//
//  Created by Mihael Isaev on 22/12/2018.
//

import Foundation

public protocol LoggerDelegate: class {
    func onAny(_ level: Logger.Level, _ message: String)
    func onCurrentLevel(_ message: String)
}

public struct Logger {
    public enum Level: Int {
        ///Don't log anything at all.
        case off
        
        ///An error is a serious issue and represents the failure of something important going on in your application.
        ///This will require someone's attention probably sooner than later, but the application can limp along.
        case error
        
        ///Finally, we can dial down the stress level.
        ///INFO messages correspond to normal application behavior and milestones.
        ///You probably won't care too much about these entries during normal operations, but they provide the skeleton of what happened.
        ///A service started or stopped. You added a new user to the database. That sort of thing.
        case info
        
        ///Here, you're probably getting into "noisy" territory and furnishing more information than you'd want in normal production situations.
        case debug
    }
    
    public enum Message {
        case off
        case error(String)
        case info(String)
        case debug(String)
        
        var rawValue: Int {
            switch self {
            case .off: return 0
            case .error: return 1
            case .info: return 2
            case .debug: return 3
            }
        }
        
        var level: Level {
            switch self {
            case .off: return .off
            case .error: return .error
            case .info: return .info
            case .debug: return .debug
            }
        }
        
        var message: String {
            switch self {
            case .off: return ""
            case .error(let v): return v
            case .info(let v): return v
            case .debug(let v): return v
            }
        }
        
        var symbol: String {
            switch self {
            case .off: return ""
            case .error: return "❗️"
            case .info: return "🔔"
            case .debug: return "❕"
            }
        }
    }
    
    public var level: Level
    public weak var delegate: LoggerDelegate?
    
    public init (_ level: Level) {
        self.level = level
    }
    
    public func log(_ message: Message...) {
        log(message)
    }
    
    func log(_ messages: [Message]) {
        let sorted = messages.sorted(by: { $0.rawValue < $1.rawValue })
        if let last = sorted.last {
            delegate?.onAny(last.level, last.message)
        }
        if let last = sorted.filter({ $0.rawValue <= self.level.rawValue }).last {
            let message = "⚡️ [WS][" + last.symbol + "]: " + last.message
            print(message)
            delegate?.onCurrentLevel(message)
        }
    }
}