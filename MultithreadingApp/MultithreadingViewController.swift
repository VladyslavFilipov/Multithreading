//
//  MultithreadingTableViewController.swift
//  MultithreadingApp
//
//  Created by Vladislav Filipov on 10.05.2018.
//  Copyright © 2018 Vladislav Filipov. All rights reserved.
//

import UIKit

class MultithreadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortTimeProgressView: UIProgressView!
    @IBOutlet weak var percentInformLabel: UILabel!
    
    let dispatchQueue = DispatchQueue.global()
    let operationQueue = OperationQueue()
    
    let sortType: [Sort] = [.quickSort, .mergeSort, .insertionSort, .selectionSort, .bubbleSort]
    let arrayOfArraysSizes = [1000, 2000, 4000, 8000, 16000]
    let sortingMethod = SortingMethods()
    let sorting = Sorting()
    var progress: Float = 0
    var arrayOfTime = [[String]]() {
        didSet { DispatchQueue.main.async {
                self.tableView.reloadData()
                self.sortTimeProgressView.progress = self.progress
                self.percentInformLabel.text = String(format: "%.0f",self.sortTimeProgressView.progress * 100) + " % "
            }   
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setArrayOfTimeToStart()
        performAsyncSorting()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sortType.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArraysSizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortInfoCell") as? CustomTableViewCell else { return UITableViewCell() }
        cell.sortTimeInfoLabel.text = arrayOfTime[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
        view.backgroundColor = UIColor.cyan
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        label.textColor = UIColor.black
        label.text = sortType[section].rawValue
        view.addSubview(label)
        return view
    }
    
    private func performAsyncSorting() {
        let iteration = 1.0/Float(sortType.count * arrayOfArraysSizes.count)
        
        operationQueue.addOperation { self.performSortingWith(sort: .quickSort, iteration, self.sortingMethod.quickSort(_:)) }
        operationQueue.addOperation { self.performSortingWith(sort: .mergeSort, iteration, self.sortingMethod.mergeSort(_:)) }
        
        dispatchQueue.async { self.performSortingWith(sort: .insertionSort, iteration, self.sortingMethod.insertSort(_:)) }
        dispatchQueue.async { self.performSortingWith(sort: .selectionSort, iteration, self.sortingMethod.selectSort(_:)) }
        dispatchQueue.async { self.performSortingWith(sort: .bubbleSort, iteration, self.sortingMethod.bubbleSort(_:)) }
    }
    
    private func performSortingWith(sort: Sort, _ iteration: Float, _ sorting: ([Int]) -> ()) {
        for index in 0..<5 { let value = self.sorting.performSorting(sorting, self.arrayOfArraysSizes[index])
            self.arrayOfTime[sortType.index(of: sort)!][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1))
            self.progress += iteration }
    }
    
//    @IBAction func startButtonTapped(_ sender: Any) {
//        progress = 0
//        operationQueue.cancelAllOperations()
//        arrayOfTime.removeAll()
//        setArrayOfTimeToStart()
//        performAsyncSorting()
//    }
    
    private func setArrayOfTimeToStart() {
        for index in 0..<sortType.count { arrayOfTime.append([])
            for _ in 0..<arrayOfArraysSizes.count { arrayOfTime[index].append("Not done yet") } }
    }
}
