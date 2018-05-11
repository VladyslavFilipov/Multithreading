//
//  MultithreadingTableViewController.swift
//  MultithreadingApp
//
//  Created by Vladislav Filipov on 10.05.2018.
//  Copyright © 2018 Vladislav Filipov. All rights reserved.
//

import UIKit

class MultithreadingTableViewController: UITableViewController {
    
    let sortType: [Sort] = [.quickSort, .mergeSort, .insertionSort, .selectionSort, .bubbleSort]
    let arrayOfArraysSizes = [1000, 2000, 4000, 8000, 16000]
    let sorting = Sorting()
    let insertion = DispatchQueue(label: "Insertion")
    let selection = DispatchQueue(label: "Selection")
    let bubble = DispatchQueue(label: "Bubble")
    let quick = DispatchQueue(label: "Quick")
    let merge = DispatchQueue(label: "Merge")
    let sort = SortingMethods()
    var arrayOfTime = [[String]]() {
        didSet{ DispatchQueue.main.async {
                self.tableView.reloadData()}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortType.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfArraysSizes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SortInfoCell") as? CustomTableViewCell else { return UITableViewCell() }
        cell.sortTimeInfoLabel.text = arrayOfTime[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 25))
        view.backgroundColor = UIColor.cyan
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.text = sortType[section].rawValue
        view.addSubview(label)
        return view
    }
    
    func updateTable() {
        for _ in 0..<5 { arrayOfTime.append(["Not done yet", "Not done yet", "Not done yet", "Not done yet", "Not done yet"]) }
        
        quick.async {for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.quickSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[0][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1)) } }
        
        merge.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.mergeSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[1][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1)) } }
        
        insertion.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.insertSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[2][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1)) } }
        
        selection.async { for index in 0..<5 {
            let value = self.sorting.performAsyncSorting(self.sort.selectionSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[3][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1)) } }
        
        bubble.async { for index in 0..<5 { let value = self.sorting.performAsyncSorting(self.sort.bubbleSort(_:), self.arrayOfArraysSizes[index])
            self.arrayOfTime[4][index] = String("For \(value.0) - " + String(format: "%.5f" ,value.1)) } }
    }
}
