//
//  MinesweeperSwiftApp.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

@main
struct MinesweeperApp: App {
  @State var currentNumber: String = "1"
  var body: some Scene {
    WindowGroup {
      MinesweeperView()
    }
      .commands {
        MinesweeperCommands()
      }
  }
}
