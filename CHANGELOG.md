# Changelog

All notable changes to ColorStudio will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added
- Initial release of ColorStudio
- Color picker with wheel and multiple slider modes (RGB, HSB, CMYK, LAB)
- Hex color input with validation
- Image color extraction using drag & drop with Core Image
- Color harmony generator with 5 harmony types:
  - Complementary
  - Triadic
  - Analogous
  - Split-Complementary
  - Tetradic
- WCAG 2.1 accessibility contrast checker with AA/AAA compliance levels
- Color blindness simulator with 8 CVD types:
  - Protanopia, Deuteranopia, Tritanopia
  - Protanomaly, Deuteranomaly, Tritanomaly
  - Achromatopsia, Achromatomaly
- Export functionality supporting 5 formats:
  - Adobe Swatch Exchange (.ase)
  - CSS Variables (.css)
  - Swift Color Extension (.swift)
  - Hex List (.txt)
  - PNG Swatch (.png)
- Menu bar color picker with screen sampling
- Collections system for organizing palettes into folders
- Full macOS dark mode support
- Keyboard shortcuts:
  - ⌘N: New palette
  - ⌘⇧P: Pick screen color
  - ⌘⇧A: Accessibility checker
- Persistent storage using UserDefaults
- MVVM architecture with reactive UI updates
- macOS 14+ native design with SwiftUI
- No external dependencies

### Technical Details
- Built with Swift 5.0
- SwiftUI for UI
- AppKit for native macOS features
- Core Image for image processing
- Supports both Intel and Apple Silicon

### Known Limitations
- Image extraction works best with images under 4K resolution
- Screen color picker requires macOS accessibility permissions
- ASE export supports RGB color space only

## [Unreleased]

### Planned Features
- iCloud sync for palettes across devices
- Custom color space conversions
- Gradient generator
- Color naming suggestions
- Import from various file formats
- Keyboard shortcuts customization
- Touch Bar support
- Quick Look plugin for palette files
- Share extension for system-wide color sharing

---

[1.0.0]: https://github.com/lopodragon/colorstudio/releases/tag/v1.0.0
