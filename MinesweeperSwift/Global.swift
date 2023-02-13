//
// Created by Liplum on 11/24/22.
//

import Foundation
import SwiftUI


struct GameCenter {
  static let gameOver = Notification.Name("GameOverEvent")
  static let newGame = Notification.Name("NewGameEvent")
}

struct GameConfig: Decodable, Encodable, Hashable, RawRepresentable {
  typealias RawValue = String
  var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8)
    else {
      return "{}"
    }
    return result
  }

  init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8),
          let result = try? JSONDecoder().decode(GameConfig.self, from: data)
    else {
      return nil
    }
    self = result
  }

  let maxX: Int
  let maxY: Int
  let mineCount: Int

  init(row x: Int, column y: Int, mines mineCount: Int) {
    maxX = x
    maxY = y
    self.mineCount = min(mineCount, maxX * maxY)
  }

  static let easy = GameConfig(row: 8, column: 8, mines: 8)
}