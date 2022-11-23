//
//  ContentView.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        var pad = Pad(row: 8, column: 8)
        pad.generateBlocks(place: 8)
        let gameView = GamePad(pad: pad)
        return gameView
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
