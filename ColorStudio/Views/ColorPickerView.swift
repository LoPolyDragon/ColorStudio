import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: ColorModel
    @State private var pickerMode: PickerMode = .wheel

    enum PickerMode: String, CaseIterable {
        case wheel = "Wheel"
        case sliders = "Sliders"
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Picker Mode", selection: $pickerMode) {
                ForEach(PickerMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Divider()

            switch pickerMode {
            case .wheel:
                ColorWheelView(selectedColor: $selectedColor)
                    .padding()
                    .frame(maxWidth: 300, maxHeight: 300)

                Divider()

                VStack(spacing: 8) {
                    HStack {
                        Text("Brightness")
                        Slider(value: .init(
                            get: { selectedColor.hsb.brightness },
                            set: { newValue in
                                let hsb = selectedColor.hsb
                                selectedColor = ColorModel(hue: hsb.hue, saturation: hsb.saturation, brightness: newValue, alpha: selectedColor.alpha)
                                selectedColor.name = selectedColor.hexString
                            }
                        ), in: 0...1)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)

            case .sliders:
                ColorSlidersView(selectedColor: $selectedColor)
                    .padding()
            }
        }
    }
}
