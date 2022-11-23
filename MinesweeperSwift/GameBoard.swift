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
            Block(entity: pad[x, y]).frame(width: blockSize, height: blockSize)
          }
        }
      }
    }
  }
}


struct Block: View {
  let entity: BlockEntity

  init(entity: BlockEntity) {
    self.entity = entity
  }

  @State
  var state: BlockState = .facedown
  @GestureState var flagging = false
  var body: some View {
    switch state {
    case .facedown:
      Color.gray
        .onTapGesture {
          state.reveal()
        }
        .onLongPressGesture(minimumDuration: 0.1) {
          state.flagOn()
        }
    case .flag:
      ZStack {
        Color.gray
        Image(systemName: "flag.fill")
      }
        .onTapGesture {
          state.reset()
        }
    default:
      if entity.mineNearby > 0 {
        Text(String(entity.mineNearby))
      } else {
        Text(" ")
      }
    }
  }
}
