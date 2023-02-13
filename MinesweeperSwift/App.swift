//
//  MinesweeperSwiftApp.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

@main
struct MinesweeperApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    Window("Minesweeper", id: "default-game") {
      MinesweeperView(id: 0, config: .easy)
    }
    WindowGroup(for: GameConfig.self) { $config in
      if let config = $config.wrappedValue {
        MinesweeperView(id: 0, config: config)
      }
    }
      .commands {
        MinesweeperCommands()
      }
    Settings {
      GameCreateView()
    }
  }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationWillUpdate(_ notification: Notification) {
    Utils.removeMainMenuItem(called: "File")
    Utils.removeMainMenuItem(called: "Edit")
  }
}

extension Utils {
  static func removeMainMenuItem(called name: String) {
    if let menu = NSApplication.shared.mainMenu {
      if let item = menu.items.first(where: { $0.title == name }) {
        menu.removeItem(item);
      }
    }
  }
}