//
//  ObserverRegistry.swift
//  FieldGuard
//
//  Created by Göksel Köksal on 04/09/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class Observer<T> {
    
    weak var object: AnyObject?
    private let onChange: ((T) -> Void)
    
    init(_ object: AnyObject, onChange: @escaping (T) -> Void) {
        self.object = object
        self.onChange = onChange
    }
    
    func notify(withValue value: T) {
        guard object != nil else { return }
        onChange(value)
    }
}

public class ObserverRegistry<T> {
    
    private var observers: [Observer<T>] = []
    
    public func addObserver(_ object: AnyObject, onChange: @escaping (T) -> Void) {
        self.observers.append(Observer(object, onChange: onChange))
    }
    
    public func removeObserver(_ object: AnyObject?) {
        guard let index = observers.index(where: { $0.object === object }) else {
            return
        }
        observers.remove(at: index)
    }
    
    public func notify(withValue value: T) {
        for observer in observers {
            observer.notify(withValue: value)
        }
        observers = observers.filter({ $0.object != nil })
    }
}
