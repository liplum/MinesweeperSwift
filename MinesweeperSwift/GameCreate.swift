//
// Created by Liplum on 11/25/22.
//

import Foundation
import SwiftUI

struct GameCreateView: View {
  @State var width = 0
  var body: some View {
    VStack {
      HStack {
        StepperField(title: "Width", value: $width)
      }
    }
  }
}

struct GameCreateView_Previews: PreviewProvider {
  static var previews: some View {
    GameCreateView()
  }
}
