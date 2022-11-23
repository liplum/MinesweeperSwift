//
// Created by Liplum on 11/23/22.
//

import Foundation


enum BlockState {
  case facedown, flag, revealed

  mutating func reveal() {
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
  static let Default = BlockEntity()
  let isMine: Bool
  let mineNearby: Int

  init(isMine: Bool = false, surroundedWith mineNearby: Int = 0) {
    self.isMine = isMine
    self.mineNearby = mineNearby
  }
}

struct Pad {
  var slots: [BlockEntity]
  let maxX, maxY: Int

  init(row x: Int, column y: Int) {
    maxX = x
    maxY = y
    slots = [BlockEntity](repeating: BlockEntity.Default, count: maxX * maxY)
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
}

extension Pad {
  mutating func generateBlocks(with mines: Int) {
    let mines = min(mines, count)
    if mines == count {
      for i in 0..<count {
        slots[i] = BlockEntity(isMine: true)
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
      for selectedIndex in selectedIndices{
        slots[selectedIndex] = BlockEntity(isMine: true)
      }


    }
  }
}
