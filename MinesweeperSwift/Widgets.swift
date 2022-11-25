//
// Created by Liplum on 11/25/22.
//

import Foundation
import SwiftUI

extension HorizontalAlignment {
  private enum ControlAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
      context[HorizontalAlignment.center]
    }
  }

  static let controlAlignment = HorizontalAlignment(ControlAlignment.self)
}

struct StepperField: View {
  let title: LocalizedStringKey
  @Binding var value: Int
  var alignToControl: Bool = false

  var body: some View {
    HStack {
      Text(title)
      TextField("Enter Value", value: $value, formatter: NumberFormatter())
        .multilineTextAlignment(.center)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .frame(minWidth: 15, maxWidth: 60)
        .alignmentGuide(.controlAlignment) {
          $0[.leading]
        }
      Stepper(title, value: $value, in: 1...100)
        .labelsHidden()
    }
      .alignmentGuide(.leading) {
        alignToControl
          ? $0[.controlAlignment]
          : $0[.leading]
      }
  }
}

struct BlockIcon {
  @ViewBuilder
  static var flag: some View {
    Image(systemName: "flag.fill").colorInvert()
  }
  @ViewBuilder
  static var mine: some View {
    Image(systemName: "sun.max")
  }
  @ViewBuilder
  static var checkmark: some View {
    Image(systemName: "checkmark.circle").colorInvert()
  }
  @ViewBuilder
  static var xmark: some View {
    Image(systemName: "xmark.circle")
  }
}

extension ColorScheme {
  @ViewBuilder
  var blockBackgroundColor: some View {
    self == .dark ? Color.gray : Color.brown
  }
  @ViewBuilder
  var blockBackground: some View {
    blockBackgroundColor
      .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
  }
}
