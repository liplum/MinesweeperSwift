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

  @State var showGameOverDialog = false

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
      .onReceive(NotificationCenter.default.publisher(for: GameCenter.gameOver)) { object in
        showGameOverDialog = true
      }
      .confirmationDialog("Game Over!", isPresented: $showGameOverDialog) {

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
      ZStack {
        blockBackground
        if pad.isGameOver && entity.isMine {
          Image(systemName: "sun.max")
            .colorInvert()
        }
      }
        .onTapGesture {
          pad.flip(block: entity)
        }
        .onLongPressGesture(minimumDuration: 0.1) {
          pad.flag(block: entity)
        }
        .contextMenu {
          if !pad.isGameOver {
            Button("Flag") {
              pad.flag(block: entity)
            }
            Button("Flip") {
              pad.flip(block: entity)
            }
          }
        }
    case .flagged:
      ZStack {
        blockBackground
        if pad.isGameOver {
          if entity.isMine {
            Image(systemName: "sun.max")
              .colorInvert()
            Image(systemName: "checkmark")
          } else {
            Image(systemName: "flag.fill")
              .colorInvert()
            Image(systemName: "xmark")
          }
        }else {
          Image(systemName: "flag.fill")
            .colorInvert()
        }
      }
        .onTapGesture {
          pad.unflag(block: entity)
        }
        .contextMenu {
          if !pad.isGameOver {
            Button("Remove Flag") {
              pad.unflag(block: entity)
            }
          }
        }
    case .revealed:
      if entity.isMine {
        Image(systemName: "sun.max")
      } else {
        Text(entity.mineNearby > 0 ? String(entity.mineNearby) : " ")
          .onTapGesture(count: 2) {
            pad.flipAround(block: entity)
          }
          .contextMenu {
            if !pad.isGameOver {
              Button("Flip Around Blocks") {
                pad.flipAround(block: entity)
              }
            }
          }
      }
    }
  }
}
