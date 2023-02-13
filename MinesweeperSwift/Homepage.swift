//
//  ContentView.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

struct MinesweeperView: View, Identifiable {
  let id: Int
  let config: GameConfig
  @StateObject var gamePad: GamePad

  init(id: Int, config: GameConfig) {
    self.id = id
    self.config = config
    let pad = GamePad(config: config)
    pad.generateBlocks()
    _gamePad = StateObject(wrappedValue: pad)
  }

  var body: some View {
    GamePadView(pad: gamePad)
    /*  .onReceive(NotificationCenter.default.publisher(for: GameCenter.newGame)) { output in
        if let config = output.object as? GameConfig {
          gamePad = GamePad(config: config)
          gamePad.generateBlocks()
        } else {
          gamePad = GamePad(config: .easy)
          gamePad.generateBlocks()
        }
      }*/
  }
}

struct MinesweeperView_Previews: PreviewProvider {
  static var previews: some View {
    MinesweeperView(id: -1, config: .easy)
  }
}
