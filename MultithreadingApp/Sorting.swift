//
//  Sorting.swift
//  MultithreadingApp
//
//  Created by Vladislav Filipov on 10.05.2018.
//  Copyright © 2018 Vladislav Filipov. All rights reserved.
//

import Foundation
import QuartzCore

enum Sort: String {
    case quickSort = "quickSort"
    case mergeSort = "mergeSort"
    case insertionSort = "insertionSort"
    case selectionSort = "selectionSort"
    case bubbleSort = "bubbleSort"
}

class Sorting {
    
    private func generateArray(_ number: Int) -> [Int] {
        var someArray: [Int] = []
        for _ in 0..<number {
            someArray.append(Int(arc4random_uniform(100000)))
        }
        return someArray
    }
    
    private func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
        let start = CACurrentMediaTime()
        block()
        let end = CACurrentMediaTime()
        return end - start
    }
    
    func performAsyncSorting(_ sorting: ([Int]) -> (), _ number: Int ) -> (Int,Double) {
        var time: Double = 0
        for _ in 1...5 {
            let timeOfSorting = self.executionTimeInterval {
                sorting(generateArray(number))
            }
            time += timeOfSorting
        }
        time /= 5
        return (number, time)
    }
}
