//
//  ContentView.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let pad = Pad(row: 8, column: 8)
        GamePad(pad: pad)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
