//
// Created by Liplum on 11/23/22.
//

import Foundation
import SwiftUI

class GameCenter {
  static let gameOver = Notification.Name("GameOverEvent")
}

enum BlockState {
  case facedown, flagged, revealed

  mutating func flip() {
    self = .revealed
  }

  mutating func flagOn() {
    self = .flagged
  }

  mutating func reset() {
    self = .facedown
  }
}

class BlockEntity: ObservableObject, Identifiable, Equatable {
  static func ==(lhs: BlockEntity, rhs: BlockEntity) -> Bool {
    lhs.id == rhs.id
  }

  let id: Int
  static let Default = BlockEntity(id: -1, x: 0, y: 0)
  var isMine: Bool = false
  var mineNearby: Int = 0
  var x, y: Int
  @Published var state: BlockState = .facedown

  init(id: Int, x: Int, y: Int) {
    self.id = id
    self.x = x
    self.y = y
  }
}

class GamePad: ObservableObject {
  let name: String
  @Published var slots: [BlockEntity]
  let maxX, maxY: Int
  @Published var isGameOver = false

  init(name: String, row x: Int, column y: Int) {
    self.name = name
    maxX = x
    maxY = y
    slots = (0..<maxX * maxY).map { index in
      BlockEntity(id: index, x: index / y, y: index % y)
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
extension GamePad {
  func generateBlocks(place mines: Int) {
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
    for (deltaX, deltaY) in GamePad.nearbyDelta {
      let nborX = deltaX + x
      let nborY = deltaY + y
      if checkInRange(nborX, nborY) && self[nborX, nborY].isMine {
        mines += 1
      }
    }
    return mines
  }

  func forEachNearbyMines(
    _ center: BlockEntity,
    query: (_ other: BlockEntity) -> Void
  ) {
    for (deltaX, deltaY) in GamePad.nearbyDelta {
      let nborX = deltaX + center.x
      let nborY = deltaY + center.y
      if checkInRange(nborX, nborY) {
        let other = self[nborX, nborY]
        query(other)
      }
    }
  }
}

/// For handling game logic
extension GamePad {

  func flip(block: BlockEntity) {
    if isGameOver {
      return
    }
    block.state.flip()
    if block.isMine {
      isGameOver = true
      NotificationCenter.default.post(name: GameCenter.gameOver, object: nil)
    } else if block.mineNearby == 0 {
      forEachNearbyMines(block) { other in
        if other.state != .revealed {
          flip(block: other)
        }
      }
    }
  }

  func flipAround(block center: BlockEntity) {
    if isGameOver {
      return
    }
    var metMine = false
    forEachNearbyMines(center) { other in
      if other.state == .facedown {
        other.state.flip()
        if other.isMine {
          metMine = true
        }
      }
    }
    if metMine {
      isGameOver = true
      NotificationCenter.default.post(name: GameCenter.gameOver, object: nil)
    }
  }

  func flag(block: BlockEntity) {
    if isGameOver {
      return
    }
    if block.state == .facedown {
      block.state.flagOn()
    }
  }

  func unflag(block: BlockEntity) {
    if isGameOver {
      return
    }
    if block.state == .flagged {
      block.state.reset()
    }
  }
}
