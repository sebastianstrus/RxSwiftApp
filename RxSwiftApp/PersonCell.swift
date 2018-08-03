//
//  PersonCell.swift
//  RxSwiftApp
//
//  Created by Sebastian Strus on 2018-08-03.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//


import Foundation
import UIKit

// TOPIC: bind UI

import RxSwift
import RxCocoa

class PersonCell: UITableViewCell {
    
    // MARK: - Properties
    var bag = DisposeBag()
    
    // MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
}

// MARK: - Internal
extension PersonCell {
    func update(with person: Person) {
        imageView?.image = person.isWoman ? #imageLiteral(resourceName: "woman") : #imageLiteral(resourceName: "man")
        textLabel?.text = person.name
    }
}
