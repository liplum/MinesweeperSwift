//
//  ContentView.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    let pad = GamePad(name: "Test Game", row: 8, column: 8)
    pad.generateBlocks(place: 8)
    return GamePadView(pad: pad)
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

