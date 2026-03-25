import SwiftUI

struct ColorWheelView: View {
    @Binding var selectedColor: ColorModel
    @State private var dragLocation: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Canvas { context, size in
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let radius = min(size.width, size.height) / 2

                    for angle in stride(from: 0, to: 360, by: 1) {
                        for radiusFraction in stride(from: 0, to: 1, by: 0.01) {
                            let hue = Double(angle) / 360.0
                            let saturation = Double(radiusFraction)
                            let color = NSColor(hue: hue, saturation: saturation, brightness: selectedColor.hsb.brightness, alpha: 1.0)

                            let x = center.x + CGFloat(radiusFraction) * radius * cos(CGFloat(angle) * .pi / 180)
                            let y = center.y + CGFloat(radiusFraction) * radius * sin(CGFloat(angle) * .pi / 180)

                            let rect = CGRect(x: x - 1, y: y - 1, width: 2, height: 2)
                            context.fill(Path(ellipseIn: rect), with: .color(Color(nsColor: color)))
                        }
                    }
                }

                let hsb = selectedColor.hsb
                let angle = hsb.hue * 360 * .pi / 180
                let radius = min(geometry.size.width, geometry.size.height) / 2
                let indicatorX = geometry.size.width / 2 + CGFloat(hsb.saturation) * radius * cos(angle)
                let indicatorY = geometry.size.height / 2 + CGFloat(hsb.saturation) * radius * sin(angle)

                Circle()
                    .strokeBorder(Color.white, lineWidth: 3)
                    .background(Circle().fill(selectedColor.color))
                    .frame(width: 20, height: 20)
                    .position(x: indicatorX, y: indicatorY)
                    .shadow(radius: 2)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateColor(at: value.location, in: geometry.size)
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func updateColor(at location: CGPoint, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let dx = location.x - center.x
        let dy = location.y - center.y
        let radius = min(size.width, size.height) / 2

        let distance = sqrt(dx * dx + dy * dy)
        let saturation = min(distance / radius, 1.0)

        var angle = atan2(dy, dx)
        if angle < 0 {
            angle += 2 * .pi
        }
        let hue = Double(angle / (2 * .pi))

        let hsb = selectedColor.hsb
        selectedColor = ColorModel(
            hue: hue,
            saturation: saturation,
            brightness: hsb.brightness,
            alpha: selectedColor.alpha
        )
        selectedColor.name = selectedColor.hexString
    }
}
