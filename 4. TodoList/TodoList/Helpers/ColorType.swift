//
//  ColorType.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/17.
//

import UIKit

// MARK: - Color Type

enum ColorType: Int, CaseIterable {
    case red
    case green
    case blue
    case purple
    
    var backgroundColor: UIColor {
        switch self {
        case .red:
            return .backgroundRed
        case .green:
            return .backgroundGreen
        case .blue:
            return .backgroundBlue
        case .purple:
            return .backgroundPurple
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .red:
            return .buttonRed
        case .green:
            return .buttonGreen
        case .blue:
            return .buttonBlue
        case .purple:
            return .buttonPurple
        }
    }
    
//    var successButtonColor: UIColor {
//        switch self {
//        case .red:
//            return .buttonRed
//        case .green:
//            return .buttonGreen
//        case .blue:
//            return .buttonBlue
//        case .purple:
//            return .buttonPurple
//        }
//    }
    
    static func findColor(_ color: UIColor) -> Int64 {
        switch color {
        case .backgroundRed: return 0
        case .backgroundGreen: return 1
        case .backgroundBlue: return 2
        case .backgroundPurple: return 3
        default: return 0
        }
    }
}
