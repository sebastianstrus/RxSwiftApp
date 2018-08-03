//
//  Person.swift
//  RxSwiftApp
//
//  Created by Sebastian Strus on 2018-08-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import Foundation
import RxSwift

class Person {

    // MARK: - Properties
    public let name: String
    public var isWoman = false
    private let age = Variable<Int>(0)
    

    var Observable: Observable<Int> {
        return age.asObservable()
    }

    // MARK: - Initializers
    init(name: String, isWoman: Bool) {
        self.name = name
        self.isWoman = isWoman
    }

    func update(_ age: Int) {
        self.age.value = age
    }
}
