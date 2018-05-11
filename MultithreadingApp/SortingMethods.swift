//
//  SortingMethods.swift
//  MultithreadingApp
//
//  Created by Vladislav Filipov on 10.05.2018.
//  Copyright © 2018 Vladislav Filipov. All rights reserved.
//

import Foundation

class SortingMethods {
    
    func quickSort(_ array: [Int]) {
        _ = quickSorting(array)
    }
    
    private func quickSorting(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        
        let pivot = array[array.count/2]
        let less = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        
        return quickSorting(less) + equal + quickSorting(greater)
    }
    
    func mergeSort(_ array: [Int]) {
        _ = mergeSorting(array)
    }
    
    private func mergeSorting(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        
        let middleIndex = array.count / 2
        let leftArray = mergeSorting(Array(array[0..<middleIndex]))
        let rightArray = mergeSorting(Array(array[middleIndex..<array.count]))
        
        return merge(leftArray, rightArray)
    }
    
    private func merge(_ left: [Int], _ right: [Int]) -> [Int] {
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedArray: [Int] = []
        
        while leftIndex < left.count && rightIndex < right.count {
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]
            
            if leftElement < rightElement {
                orderedArray.append(leftElement)
                leftIndex += 1
            } else if leftElement > rightElement {
                orderedArray.append(rightElement)
                rightIndex += 1
            } else {
                orderedArray.append(leftElement)
                leftIndex += 1
                orderedArray.append(rightElement)
                rightIndex += 1
            }
        }
        
        while leftIndex < left.count {
            orderedArray.append(left[leftIndex])
            leftIndex += 1
        }
        while rightIndex < right.count {
            orderedArray.append(right[rightIndex])
            rightIndex += 1
        }
        return orderedArray
    }
    
    func insertSort(_ array: [Int]) {
        guard array.count > 1 else { return }
        
        var newArray = array
        for number in 1..<newArray.count {
            var index = number
            let temp = newArray[index]
            while index > 0 && temp < newArray[index - 1] {
                newArray[index] = newArray[index - 1]
                index -= 1
            }
            newArray[index] = temp
        }
    }
    
    func selectionSort(_ array: [Int]) {
        guard array.count > 1 else { return }
        
        var newArray = array
        for number in 0..<newArray.count - 1 {
            var lowest = number
            for somenumber in number + 1 ..< newArray.count {
                if newArray[somenumber] < newArray[lowest] {
                    lowest = somenumber
                }
            }
            if number != lowest {
                newArray.swapAt(number, lowest)
            }
        }
    }
    
    func bubbleSort(_ array: [Int]) {
        var arrayResult = array
        var temp: Int = 0
        for index in 0 ... arrayResult.count-1 {
            for newIndex in index ... arrayResult.count-1 {
                if array[newIndex] < arrayResult[index] {
                    temp = arrayResult[index]
                    arrayResult[index] = arrayResult[newIndex]
                    arrayResult[newIndex] = temp
                }
            }
        }
    }
}
