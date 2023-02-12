//
// Created by Liplum on 11/24/22.
//

import Foundation
import SwiftUI


struct GameCenter {
  static let gameOver = Notification.Name("GameOverEvent")
  static let newGame = Notification.Name("NewGameEvent")
}

struct GameConfig: Decodable, Encodable, Hashable {
  let name: String
  let maxX: Int
  let maxY: Int
  let mineCount: Int

  init(name: String, row x: Int, column y: Int, mines mineCount: Int) {
    self.name = name
    maxX = x
    maxY = y
    self.mineCount = min(mineCount, maxX * maxY)
  }

  static let easy = GameConfig(name: "easy", row: 8, column: 8, mines: 8)
}