//
//  GestureType.swift
//  SwiftyTesterX
//
//  Created by Ильдар Арсламбеков on 13.04.2024.
//

enum GestureType {
    
    enum SwipeDirection {
        case up
        case down
        case left
        case right
    }
    
    case tap
    case swipe(direction: SwipeDirection)
}
