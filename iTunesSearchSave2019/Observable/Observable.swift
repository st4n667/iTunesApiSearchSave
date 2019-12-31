//
//  Observable.swift
//  iTunesSearchSave2019
//
//  Created by Staszek on 22/12/2019.
//  Copyright © 2019 st4n. All rights reserved.
//

import Foundation

class Observable<T: Equatable> {
    typealias Callback = (T) -> Void
    private var bindingType: BindingType = []
    private var callback: Callback?
    
    var value: T {
        didSet {
            if bindingType.contains(.update) && oldValue == value {
                return
            }
            callback?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ type: BindingType = .initial, callback: Callback?) {
        self.callback = callback
        self.bindingType = type
        
        if type.contains(.initial) {
            callback?(value)
        }
    }
}

struct BindingType: OptionSet {
    let rawValue: Int
    
    static let initial  = BindingType(rawValue: 1 << 0)
    static let new      = BindingType(rawValue: 1 << 1)
    static let update   = BindingType(rawValue: 1 << 2)
}
