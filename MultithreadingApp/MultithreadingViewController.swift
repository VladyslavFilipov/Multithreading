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
    
    let sortType: [Sort] = [.quickSort, .mergeSort, .insertionSort, .selectionSort, .bubbleSort]
    let arrayOfArraysSizes = [1000, 2000, 4000, 8000, 16000]
    let insertion = DispatchQueue(label: "Insertion")
    let selection = DispatchQueue(label: "Selection")
    let bubble = DispatchQueue(label: "Bubble")
    let quick = DispatchQueue(label: "Quick")
    let merge = DispatchQueue(label: "Merge")
    let sort = SortingMethods()
    let sorting = Sorting()
    var progress: Float = 0
    var arrayOfTime = [[String]]() {
        didSet { DispatchQueue.main.async {
                self.tableView.reloadData()
                self.sortTimeProgressView.progress = self.progress
                self.percentInformLabel.text = "\(self.progress * 100) %"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
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
    
    func updateTable() {
        let iteration = 1.0/Float(sortType.count * arrayOfArraysSizes.count)
        for index in 0..<sortType.count { arrayOfTime.append([])
            for _ in 0..<arrayOfArraysSizes.count { arrayOfTime[index].append("Not done yet") } }
        
        quick.async {for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.quickSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[0][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1))
            self.progress += iteration } }
        
        merge.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.mergeSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[1][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1))
            self.progress += iteration } }
        
        insertion.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.insertSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[2][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1))
            self.progress += iteration } }
        
        selection.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.selectSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[3][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1))
            self.progress += iteration } }
        
        bubble.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.bubbleSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[4][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1))
            self.progress += iteration } }
    }
}
