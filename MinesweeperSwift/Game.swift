//
//  Game.swift
//  MinesweeperSwift
//
//  Created by Liplum on 11/22/22.
//

import Foundation
import SwiftUI

enum EntityType{
    case Mine,Flag,Empty
}

struct BlockEntity {
    static let Default = BlockEntity(type: .Empty, surroundedWith: 0)
    let type:EntityType
    let mineNearby :Int
    init(type:EntityType = .Empty,surroundedWith mineNearby:Int = 0){
        self.type = type
        self.mineNearby = mineNearby;
    }
}

struct Pad{
    let slots:[BlockEntity]
    let maxX,maxY:Int
    init(row x:Int,column y:Int){
        self.maxX = x
        self.maxY = y
        self.slots = [BlockEntity](repeating: BlockEntity.Default, count: maxX * maxY)
    }
}

struct GamePad :View{
    let pad:Pad
    init(pad:Pad){
        self.pad = pad
    }
    var body: some View{
        Grid{
            ForEach(0..<self.pad.maxX,id: \.self){x in
                GridRow{
                    ForEach(0..<self.pad.maxY,id:\.self){ y in
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                }}
            }
        }
    }
}

struct Block:View{
    @State
    var isRevealed:Bool=false
    var body: some View{
        Button(action: {
            
        }){
            Text(String(1))
        }.clipShape(Rectangle())
    }
}
