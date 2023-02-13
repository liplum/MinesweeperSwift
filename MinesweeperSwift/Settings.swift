//
// Created by Liplum on 11/25/22.
//

import Foundation
import SwiftUI

struct GameSettingsView: View {
  @State var row: Int
  @State var column: Int
  @State var mines: Int

  init() {
    let defaultGameConfig = UserDefaults.standard.object(forKey: "Default-Game-Config") as? GameConfig ?? .easy
    row = defaultGameConfig.maxX
    column = defaultGameConfig.maxY
    mines = defaultGameConfig.mineCount
  }

  var body: some View {
    VStack(alignment: .leading) {
      StepperField(title: "Row", value: $row)
      StepperField(title: "Colum", value: $column)
      StepperField(title: "Mines", value: $mines)
      Button("Save") {
        let config = GameConfig(row: row, column: column, mines: mines)
        UserDefaults.standard.set(config, forKey: "Default-Game-Config")
      }
    }
  }
}

struct GameCreateView_Previews: PreviewProvider {
  static var previews: some View {
    GameSettingsView()
  }
}
