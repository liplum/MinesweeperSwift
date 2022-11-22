//
//  Game.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import Foundation
import SwiftUI


struct BlockEntity {
    static let Default = BlockEntity()
    let isMine: Bool
    let mineNearby: Int

    init(isMine: Bool = false, surroundedWith mineNearby: Int = 0) {
        self.isMine = isMine
        self.mineNearby = mineNearby
    }
}

struct Pad {
    var slots: [BlockEntity]
    let maxX, maxY: Int

    init(row x: Int, column y: Int) {
        maxX = x
        maxY = y
        slots = [BlockEntity](repeating: BlockEntity.Default, count: maxX * maxY)
    }

    subscript(x: Int, y: Int) -> BlockEntity {
        get {
            slots[x * maxY + y]
        }
        set(newValue) {
            slots[x * maxY + y] = newValue
        }
    }
}

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

enum BlockState {
    case facedown, flag, revealed

    mutating func reveal() {
        self = .revealed
    }

    mutating func flagOn() {
        self = .flag
    }
}

struct Block: View {
    let entity: BlockEntity
    let size: CGFloat

    init(entity: BlockEntity, size: CGFloat = 24) {
        self.entity = entity
        self.size = size
    }

    @State
    var state: BlockState = .facedown
    var body: some View {
        switch state {
        case .facedown:
            Button{
                state.reveal()
            } label: {
                Color.gray
            }.buttonStyle(BorderlessButtonStyle())
        case .flag:
            Image(systemName: "flag.fill")
        default:
            if entity.mineNearby > 0 {
                Text(String(entity.mineNearby))
            } else {
                Text(" ")
            }

        }
    }
}
