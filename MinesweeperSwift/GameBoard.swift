//
//  GameBoard.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import Foundation
import SwiftUI


struct GamePadView: View {
  @ObservedObject var pad: GamePad
  let margin: CGFloat
  let blockSize: CGFloat

  init(pad: GamePad, blockSize: CGFloat = 24, margin: CGFloat = 1) {
    self.pad = pad
    self.margin = margin
    self.blockSize = blockSize
  }

  var body: some View {
    Grid(horizontalSpacing: margin, verticalSpacing: margin) {
      ForEach(0..<pad.maxX, id: \.self) { x in
        GridRow {
          ForEach(0..<pad.maxY, id: \.self) { y in
            let blockEntity = pad[x, y]
            Block(entity: blockEntity, pad: pad)
              .frame(width: blockSize, height: blockSize)
          }
        }
      }
    }
  }
}


struct Block: View {
  @ObservedObject var entity: BlockEntity
  @ObservedObject var pad: GamePad

  init(
    entity: BlockEntity,
    pad: GamePad
  ) {
    self.entity = entity
    self.pad = pad
  }

  @Environment(\.colorScheme)
  var colorScheme
  @GestureState var flagging = false
  var blockBackground: some View {
    get {
      colorScheme == .dark ? Color.gray : Color.brown
    }
  }

  var body: some View {
    switch entity.state {
    case .facedown:
      blockBackground
        .onTapGesture {
          pad.flip(block: entity)
        }
        .onLongPressGesture(minimumDuration: 0.1) {
          entity.state.flagOn()
        }
    case .flag:
      ZStack {
        blockBackground
        let flagImg = Image(systemName: "flag.fill")
        flagImg.colorInvert()
      }
        .onTapGesture {
          entity.state.reset()
        }
    case .revealed:
      if entity.isMine {
        Image(systemName: "sun.max")
      } else {
        if entity.mineNearby > 0 {
          Text(String(entity.mineNearby))
        } else {
          Text(" ")
        }
      }
    }
  }
}
