//
// Created by Liplum on 11/23/22.
//

import Foundation


enum BlockState {
  case facedown, flag, revealed

  mutating func flip() {
    self = .revealed
  }

  mutating func flagOn() {
    self = .flag
  }

  mutating func reset() {
    self = .facedown
  }
}

struct BlockEntity {
  static let Default = BlockEntity(x: 0, y: 0)
  var isMine: Bool = false
  var mineNearby: Int = 0
  var x, y: Int

  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

struct Pad {
  var slots: [BlockEntity]
  let maxX, maxY: Int

  init(row x: Int, column y: Int) {
    maxX = x
    maxY = y
    slots = (0..<maxX * maxY).map { index in
      BlockEntity(x: index / y, y: index % y)
    }
  }

  subscript(x: Int, y: Int) -> BlockEntity {
    get {
      slots[x * maxY + y]
    }
    set(newValue) {
      slots[x * maxY + y] = newValue
    }
  }

  subscript(index: Int) -> BlockEntity {
    get {
      slots[index]
    }
    set(newValue) {
      slots[index] = newValue
    }
  }

  var count: Int {
    get {
      slots.count
    }
  }

  func checkInRange(_ x: Int, _ y: Int) -> Bool {
    0 <= x && x < maxX && 0 <= y && y < maxY
  }

  func packCoord(x: Int, y: Int) -> Int {
    x * maxY + y
  }

  func unpackCoord(index: Int) -> (x: Int, y: Int) {
    (index / maxY, index % maxY)
  }
}

/// For generating blocks
extension Pad {
  mutating func generateBlocks(place mines: Int) {
    let mines = min(mines, count)
    if mines == count {
      for i in 0..<count {
        slots[i].isMine = true
      }
    } else {
      var restIndices = [Int](0..<count)
      var selectedIndices = [Int]()
      for _ in 0..<mines {
        let selectedIndexInRest = Int.random(in: 0..<restIndices.count)
        let selectedIndex2Add = restIndices[selectedIndexInRest]
        restIndices.remove(at: selectedIndexInRest)
        selectedIndices.append(selectedIndex2Add)
      }
      for selectedIndex in selectedIndices {
        slots[selectedIndex].isMine = true
      }
    }
    for x in 0..<maxX {
      for y in 0..<maxY {
        let entity = self[x, y]
        if !entity.isMine {
          self[x, y].mineNearby = countNearbyMines(x, y)
        }
      }
    }
  }

  static let nearbyDelta = [
    (-1, 1), (0, 1), (1, 1),
    (-1, 0), /*(0,0)*/(1, 0),
    (-1, -1), (0, -1), (1, -1)
  ]

  func countNearbyMines(_ x: Int, _ y: Int) -> Int {
    var mines = 0
    for (deltaX, deltaY) in Pad.nearbyDelta {
      let nborX = deltaX + x
      let nborY = deltaY + y
      if checkInRange(nborX, nborY) && self[nborX, nborY].isMine {
        mines += 1
      }
    }
    return mines
  }
}

/// For handling game logic
extension Pad {

}
