//
// Created by Liplum on 11/25/22.
//

import Foundation
import SwiftUI

struct MinesweeperCommands: Commands {
  var body: some Commands {
    CommandMenu("Game") {
      Button("New Game") {
        NotificationCenter.default.post(name: GameCenter.newGame, object: nil)
      }
        .keyboardShortcut("n", modifiers: [.command])
    }
  }
}

func openGameCreateWindow() {
  var windowRef: NSWindow
  windowRef = NSWindow(
    contentRect: NSRect(x: 100, y: 100, width: 100, height: 600),
    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
    backing: .buffered, defer: false)
  windowRef.contentView = NSHostingView(rootView: GameCreateView())
  windowRef.makeKeyAndOrderFront(nil)
}