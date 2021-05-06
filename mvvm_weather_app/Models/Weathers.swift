//
//  State.swift
//  mvvm_weather_app
//
//  Created by Gerwin on 06.05.21.
//

import Foundation

struct Weathers {
    private(set) var cityWeathers: [Weather]
    
    enum EditingStyle {
        case insert(Weather, IndexPath)
        case delete(IndexPath)
        case none
    }
    var editingStyle: EditingStyle {
        didSet {
            switch editingStyle {
            case let .insert(new, indexPath):
                cityWeathers.insert(new, at: indexPath.row)
            case let .delete(indexPath):
                cityWeathers.remove(at: indexPath.row)
            default:
                break
            }
        }
    }
    
    init(cityWeathers: [Weather]) {
        self.cityWeathers = cityWeathers
        self.editingStyle = .none
    }
    
    
}
