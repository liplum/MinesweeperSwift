//
//  GameBoard.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import Foundation
import SwiftUI


struct GamePad: View {
  let pad: Pad
  let margin: CGFloat
  let blockSize: CGFloat

  init(pad: Pad, blockSize: CGFloat = 24, margin: CGFloat = 1) {
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
            Block(entity: blockEntity, coord: (x, y)) {

            }
              .frame(width: blockSize, height: blockSize)
          }
        }
      }
    }
  }
}


struct Block: View {
  let entity: BlockEntity
  let coord: (x: Int, y: Int)
  let onFlip: () -> Void

  init(
    entity: BlockEntity, coord: (x: Int, y: Int),
    onFlip: @escaping () -> Void
  ) {
    self.entity = entity
    self.coord = coord
    self.onFlip = onFlip
  }

  @State
  var state: BlockState = .facedown
  @Environment(\.colorScheme)
  var colorScheme
  @GestureState var flagging = false
  var blockBackground: some View {
    get {
      colorScheme == .dark ? Color.gray : Color.brown
    }
  }

  var body: some View {
    switch state {
    case .facedown:
      blockBackground
        .onTapGesture {
          state.flip()
        }
        .onLongPressGesture(minimumDuration: 0.1) {
          state.flagOn()
        }
    case .flag:
      ZStack {
        blockBackground
        let flagImg = Image(systemName: "flag.fill")
          flagImg.colorInvert()
      }
        .onTapGesture {
          state.reset()
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
