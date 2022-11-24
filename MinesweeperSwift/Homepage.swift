//
//  ContentView.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

struct MinesweeperView: View {
  @State var gamePad: GamePad

  init() {
    gamePad = GamePad(name: "Test Game", row: 8, column: 8, mines: 8)
    gamePad.generateBlocks()
  }

  var body: some View {
    GamePadView(pad: gamePad)
      .onReceive(NotificationCenter.default.publisher(for: GameCenter.newGame)) { object in
        gamePad = GamePad(name: "Test Game", row: 8, column: 8, mines: 8)
        gamePad.generateBlocks()
      }
  }
}

struct MinesweeperView_Previews: PreviewProvider {
  static var previews: some View {
    MinesweeperView()
  }
}
