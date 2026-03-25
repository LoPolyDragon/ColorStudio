import SwiftUI

enum ColorSliderMode: String, CaseIterable {
    case rgb = "RGB"
    case hsb = "HSB"
    case cmyk = "CMYK"
    case lab = "LAB"
}

struct ColorSlidersView: View {
    @Binding var selectedColor: ColorModel
    @State private var mode: ColorSliderMode = .rgb
    @State private var hexInput: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Picker("Mode", selection: $mode) {
                ForEach(ColorSliderMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            switch mode {
            case .rgb:
                rgbSliders
            case .hsb:
                hsbSliders
            case .cmyk:
                cmykSliders
            case .lab:
                labSliders
            }

            Divider()

            HStack {
                TextField("Hex", text: $hexInput)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        if hexInput.hasPrefix("#"), hexInput.count == 7 {
                            selectedColor = ColorModel(hex: hexInput)
                            selectedColor.name = hexInput
                        }
                    }
                    .onChange(of: selectedColor) { _, newValue in
                        hexInput = newValue.hexString
                    }

                Rectangle()
                    .fill(selectedColor.color)
                    .frame(width: 60, height: 30)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .onAppear {
            hexInput = selectedColor.hexString
        }
    }

    private var rgbSliders: some View {
        VStack(spacing: 12) {
            SliderRow(label: "R", value: $selectedColor.red, range: 0...1, color: .red) {
                selectedColor.name = selectedColor.hexString
            }
            SliderRow(label: "G", value: $selectedColor.green, range: 0...1, color: .green) {
                selectedColor.name = selectedColor.hexString
            }
            SliderRow(label: "B", value: $selectedColor.blue, range: 0...1, color: .blue) {
                selectedColor.name = selectedColor.hexString
            }
            SliderRow(label: "A", value: $selectedColor.alpha, range: 0...1, color: .gray) {
                selectedColor.name = selectedColor.hexString
            }
        }
    }

    private var hsbSliders: some View {
        VStack(spacing: 12) {
            let hsb = selectedColor.hsb
            SliderRow(label: "H", value: .constant(hsb.hue), range: 0...1, color: .red) { newValue in
                selectedColor = ColorModel(hue: newValue, saturation: hsb.saturation, brightness: hsb.brightness, alpha: selectedColor.alpha)
                selectedColor.name = selectedColor.hexString
            }
            SliderRow(label: "S", value: .constant(hsb.saturation), range: 0...1, color: .orange) { newValue in
                selectedColor = ColorModel(hue: hsb.hue, saturation: newValue, brightness: hsb.brightness, alpha: selectedColor.alpha)
                selectedColor.name = selectedColor.hexString
            }
            SliderRow(label: "B", value: .constant(hsb.brightness), range: 0...1, color: .yellow) { newValue in
                selectedColor = ColorModel(hue: hsb.hue, saturation: hsb.saturation, brightness: newValue, alpha: selectedColor.alpha)
                selectedColor.name = selectedColor.hexString
            }
            SliderRow(label: "A", value: $selectedColor.alpha, range: 0...1, color: .gray) {
                selectedColor.name = selectedColor.hexString
            }
        }
    }

    private var cmykSliders: some View {
        VStack(spacing: 12) {
            let cmyk = selectedColor.cmyk
            Text("C: \(Int(cmyk.cyan * 100))%")
            Text("M: \(Int(cmyk.magenta * 100))%")
            Text("Y: \(Int(cmyk.yellow * 100))%")
            Text("K: \(Int(cmyk.black * 100))%")
        }
        .font(.system(.body, design: .monospaced))
    }

    private var labSliders: some View {
        VStack(spacing: 12) {
            let lab = selectedColor.lab
            Text("L: \(Int(lab.l))")
            Text("a: \(Int(lab.a))")
            Text("b: \(Int(lab.b))")
        }
        .font(.system(.body, design: .monospaced))
    }
}

struct SliderRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    var onChange: (() -> Void)?
    var onChangeWithValue: ((Double) -> Void)?

    var body: some View {
        HStack {
            Text(label)
                .frame(width: 20)
                .font(.system(.body, design: .monospaced))

            if let onChangeWithValue = onChangeWithValue {
                Slider(value: .init(get: { value }, set: { newValue in
                    onChangeWithValue(newValue)
                }), in: range)
                    .accentColor(color)
            } else {
                Slider(value: $value, in: range)
                    .accentColor(color)
                    .onChange(of: value) { _, _ in
                        onChange?()
                    }
            }

            Text("\(Int(value * (label == "A" ? 100 : 255)))")
                .frame(width: 40, alignment: .trailing)
                .font(.system(.caption, design: .monospaced))
        }
    }
}
