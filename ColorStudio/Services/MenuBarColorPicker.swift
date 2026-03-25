import AppKit
import SwiftUI

class MenuBarColorPicker: ObservableObject {
    @Published var pickedColor: ColorModel?
    private var eventMonitor: Any?
    private var isPickingColor = false
    private var magnifierWindow: NSWindow?

    func startPicking(completion: @escaping (ColorModel) -> Void) {
        guard !isPickingColor else { return }
        isPickingColor = true

        NSCursor.crosshair.push()

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown]) { [weak self] event in
            guard let self = self else { return }

            let location = NSEvent.mouseLocation
            if let color = self.getPixelColor(at: location) {
                let colorModel = ColorModel(nsColor: color, name: color.hexString)
                self.pickedColor = colorModel
                completion(colorModel)
            }

            self.stopPicking()
        }

        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown]) { [weak self] event in
            guard let self = self else { return event }

            let location = NSEvent.mouseLocation
            if let color = self.getPixelColor(at: location) {
                let colorModel = ColorModel(nsColor: color, name: color.hexString)
                self.pickedColor = colorModel
                completion(colorModel)
            }

            self.stopPicking()
            return nil
        }
    }

    func stopPicking() {
        guard isPickingColor else { return }
        isPickingColor = false

        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }

        NSCursor.pop()
        magnifierWindow?.close()
        magnifierWindow = nil
    }

    private func getPixelColor(at point: CGPoint) -> NSColor? {
        guard let screen = NSScreen.main else { return nil }

        let screenHeight = screen.frame.height
        let flippedY = screenHeight - point.y

        let rect = CGRect(x: point.x, y: flippedY, width: 1, height: 1)

        guard let image = CGWindowListCreateImage(
            rect,
            .optionOnScreenOnly,
            kCGNullWindowID,
            .bestResolution
        ) else {
            return nil
        }

        let ciImage = CIImage(cgImage: image)
        let context = CIContext()

        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }

        let pixelData = cgImage.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo = 0

        let r = CGFloat(data[pixelInfo]) / 255.0
        let g = CGFloat(data[pixelInfo + 1]) / 255.0
        let b = CGFloat(data[pixelInfo + 2]) / 255.0

        return NSColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
