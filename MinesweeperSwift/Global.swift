//
// Created by Liplum on 11/24/22.
//

import Foundation
import SwiftUI


struct GameCenter {
  static let gameOver = Notification.Name("GameOverEvent")
  static let newGame = Notification.Name("NewGameEvent")
}

struct GameConfig {
  let maxX: Int
  let maxY: Int
  let mineCount: Int

  init(row x: Int, column y: Int, mines mineCount: Int) {
    maxX = x
    maxY = y
    self.mineCount = min(mineCount, maxX * maxY)
  }
}