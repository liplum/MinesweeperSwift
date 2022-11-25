//
// Created by Liplum on 11/24/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct GameCenter {
  static let gameOver = Notification.Name("GameOverEvent")
  static let newGame = Notification.Name("NewGameEvent")
}

extension UTType {
  struct Name {
    static var flag = "net.liplum.minesweeper.flag"
  }

  static var flag = UTType(exportedAs: Name.flag)
}