//
//  ViewController.swift
//  RxSwiftApp
//
//  Created by Sebastian Strus on 2018-08-02.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    fileprivate let bag = DisposeBag()
    
    //input
    fileprivate let allPeople = Variable<[Person]>([])
    //output
    fileprivate let peopleInTable = Variable<[Person]>([])
    
    // MARK: - IBOutlets
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        //initialize data
        allPeople.value = [Person(name: "Sebastian", isWoman: false), Person(name: "Jonatan", isWoman: false), Person(name: "Emilia", isWoman: true), Person(name: "Henryk", isWoman: false), Person(name: "Anna", isWoman: true), Person(name: "Tom", isWoman: false), Person(name: "Maria", isWoman: true)]
        peopleInTable.value = allPeople.value
        
        //bind UI
        bindUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleInTable.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonCell
        
        let person = peopleInTable.value[indexPath.row]
        cell.update(with: person)
        
        return cell
    }
}


// MARK: - Internal
extension ViewController {
    
    func bindUI() {
        Observable.combineLatest(
            allPeople.asObservable(),
            genderSwitch.rx.isOn,
            searchTF.rx.text,
            resultSelector: { currentPeople, onlyWomen, search in
                
                return currentPeople.filter { person -> Bool in
                    return shouldDisplayPerson(person: person, onlyWomen: onlyWomen, search: search)
                }
                
        })
            .bindTo(peopleInTable)
            .addDisposableTo(bag)
        
        peopleInTable.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .addDisposableTo(bag)
    }
}

// MARK: - Functions
fileprivate func shouldDisplayPerson(person: Person, onlyWomen: Bool, search: String?) -> Bool {
    if onlyWomen && !person.isWoman {
        return false
    }
    
    if let search = search,
        !search.isEmpty,
        !person.name.contains(search) {
        return false
    }
    return true
}

fileprivate func update(people: [Person], with newPeople: [String: Int]) -> [Person] {
    for (key, newPerson) in newPeople {
        if let person = people.filter({ $0.name == key }).first {
            person.update(newPerson)
        }
    }
    return people
}

