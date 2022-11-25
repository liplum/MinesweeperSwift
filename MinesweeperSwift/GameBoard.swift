//
//  GameBoard.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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
    VStack {
      GameHeader(pad: pad).fixedSize()
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
      .padding(.top, 10)
      .onReceive(NotificationCenter.default.publisher(for: GameCenter.gameOver)) { object in
        showGameOverDialog = true
      }
      .confirmationDialog("Game Over!", isPresented: $showGameOverDialog) {

      }
  }
}

struct GameHeader: View {
  @ObservedObject var pad: GamePad

  let blockSize: CGFloat

  init(pad: GamePad, blockSize: CGFloat = 24) {
    self.pad = pad

    self.blockSize = blockSize
  }

  @Environment(\.colorScheme)
  var colorScheme
  var body: some View {
    ZStack {
      HStack {
        if !pad.isGameOver {
          Image(systemName: "flag.fill").onDrag {
            NSItemProvider(object: NSString("flag"))
          }
        }
        Spacer()
      }
      let face = pad.isGameOver ?
        Image(systemName: "xmark.circle") :
        Image(systemName: "face.smiling")
      face
        .resizable()
        .frame(width: blockSize, height: blockSize)
      HStack {
        Spacer(minLength: 80)
        Text("\(pad.flagCount) / \(pad.mineCount)")
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

  var body: some View {
    switch entity.state {
    case .facedown:
      ZStack {
        colorScheme.blockBackground
        if pad.isGameOver && entity.isMine {
          BlockIcon.mine
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
        .onDrop(of: [UTType.text], isTargeted: nil) { providers in
          pad.flag(block: entity)
          return true
        }
    case .flagged:
      ZStack {
        colorScheme.blockBackground
        if pad.isGameOver {
          if entity.isMine {
            BlockIcon.checkmark
          } else {
            BlockIcon.xmark
          }
        } else {
          BlockIcon.flag
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
        BlockIcon.mine
      } else {
        Text(entity.mineNearby > 0 ? String(entity.mineNearby) : " ")
          .onTapGesture(count: 2) {
            pad.flipAround(block: entity)
          }
          .contextMenu {
            if !pad.isGameOver && entity.mineNearby > 0 {
              Button("Flip Around Blocks") {
                pad.flipAround(block: entity)
              }
                .disabled(!pad.canFlipAround(block: entity))
            }
          }
      }
    }
  }
}