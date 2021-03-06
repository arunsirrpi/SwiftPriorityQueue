//
//  SwiftPriorityQueue.swift
//  SwiftPriorityQueue
//
//  Copyright (c) 2015 David Kopec
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

// This code was inspired by Section 2.4 of Algorithms by Sedgewick & Wayne, 4th Edition

/// A PriorityQueue takes objects to be pushed of any type that implements Comparable.
/// It will pop the objects in the order that they would be sorted. A pop() or a push()
/// can be accomplished in O(lg n) time. It can be specified whether the objects should
/// be popped in ascending or descending order (Max Priority Queue or Min Priority Queue)
/// at the time of initialization.
struct PriorityQueue<T: Comparable> {
    
    private var heap = [T]()
    private let ordered: (T, T) -> Bool
    
    init(ascending: Bool = false, startingValues: [T] = []) {
        
        if ascending {
            ordered = { $0 > $1 }
        } else {
            ordered = { $0 < $1 }
        }
        
        for value in startingValues { push(value) }
    }
    
    /// How many elements the Priority Queue stores
    var count: Int { return heap.count }
    
    /// true if and only if the Priority Queue is empty
    var isEmpty: Bool { return heap.isEmpty }
    
    /// Add a new element onto the Priority Queue. O(lg n)
    ///
    /// :param: element The element to be inserted into the Priority Queue.
    mutating func push(element: T) {
        heap.append(element)
        swim(heap.count - 1)
    }
    
    /// Remove and return the element with the highest priority (or lowest if ascending). O(lg n)
    ///
    /// :returns: The element with the highest priority in the Priority Queue, or nil if the PriorityQueue is empty.
    mutating func pop() -> T? {
        
        if heap.isEmpty { return nil }
        
        swap(&heap[0], &heap[heap.count - 1])
        let temp = heap.removeLast()
        sink(0)
        
        return temp
    }
    
    /// Get a look at the current highest priority item, without removing it. O(1)
    ///
    /// :returns: The element with the highest priority in the PriorityQueue, or nil if the PriorityQueue is empty.
    func peek() -> T? {
        return heap.first
    }
    
    /// Eliminate all of the elements from the Priority Queue.
    mutating func clear() {
        heap.removeAll(keepCapacity: false)
    }
    
    // Based on example from Sedgewick p 316
    private mutating func sink(var index: Int) {
        
        while 2 * index + 1 < heap.count {
            
            var j = 2 * index + 1
            
            if j < (heap.count - 1) && ordered(heap[j], heap[j + 1]) { j++ }
            if !ordered(heap[index], heap[j]) { break }
            
            swap(&heap[index], &heap[j])
            index = j
        }
    }
    
    // Based on example from Sedgewick p 316
    private mutating func swim(var index: Int) {
        
        while index > 0 && ordered(heap[(index - 1) / 2], heap[index]) {
            swap(&heap[(index - 1) / 2], &heap[index])
            index = (index - 1) / 2
        }
    }
}

// MARK: - GeneratorType
extension PriorityQueue: GeneratorType {
    
    typealias Element = T
    mutating func next() -> Element? { return pop() }
}

// MARK: - SequenceType
extension PriorityQueue: SequenceType {
    
    typealias Generator = PriorityQueue
    func generate() -> Generator { return self }
}

// MARK: - CollectionType
extension PriorityQueue: CollectionType {
    
    typealias Index = Int
    
    var startIndex: Int { return heap.startIndex }
    var endIndex: Int { return heap.endIndex }
    
    subscript(i: Int) -> T { return heap[i] }
}

// MARK: - Printable, DebugPrintable
extension PriorityQueue: Printable, DebugPrintable {
    
    var description: String { return heap.description }
    var debugDescription: String { return heap.debugDescription }
}
