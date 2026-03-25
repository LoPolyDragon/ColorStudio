# ColorStudio

Professional color palette creator and manager for macOS 14+

![ColorStudio](https://img.shields.io/badge/Platform-macOS%2014+-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

ColorStudio is a professional-grade color palette creation and management tool designed exclusively for macOS. Built with SwiftUI and AppKit, it offers a comprehensive suite of tools for designers, developers, and digital artists who work with color.

## Features

### 🎨 Color Picker
- **Color Wheel**: Intuitive circular color picker with saturation and brightness controls
- **Multiple Slider Modes**: RGB, HSB, CMYK, and LAB color space sliders
- **Hex Input**: Direct hex code input with real-time preview
- **Live Preview**: See your selected color in real-time

### 🖼️ Image Color Extraction
- **Drag & Drop**: Simply drag any image to extract dominant colors
- **Smart Detection**: Advanced Core Image algorithm identifies up to 8 dominant colors
- **One-Click Add**: Add extracted colors directly to your palette

### 🌈 Color Harmony Generator
- **Complementary**: Generate perfectly complementary colors
- **Triadic**: Create balanced triadic color schemes
- **Analogous**: Generate harmonious analogous colors
- **Split-Complementary**: Advanced split-complementary schemes
- **Tetradic**: Four-color rectangular harmonies

### ♿️ Accessibility Checker
- **WCAG Compliance**: Check contrast ratios against WCAG 2.1 standards
- **Multiple Levels**: Test AA and AAA compliance for normal and large text
- **Visual Preview**: See text on background in real-time
- **Detailed Ratios**: Get exact contrast ratio calculations

### 👁️ Color Blindness Simulator
- **8 Simulation Types**:
  - Protanopia (Red-Blind)
  - Deuteranopia (Green-Blind)
  - Tritanopia (Blue-Blind)
  - Protanomaly (Red-Weak)
  - Deuteranomaly (Green-Weak)
  - Tritanomaly (Blue-Weak)
  - Achromatopsia (Monochromacy)
  - Achromatomaly (Blue Cone Monochromacy)
- **Side-by-Side Comparison**: View original and simulated palettes together

### 💾 Export Formats
- **ASE**: Adobe Swatch Exchange format for Adobe Creative Suite
- **CSS**: CSS custom properties (variables) ready to use
- **Swift**: Swift Color extension for iOS/macOS development
- **Hex List**: Simple text file with hex codes
- **PNG Swatch**: Visual color swatch image

### 🖱️ Menu Bar Color Picker
- **Screen Sampling**: Pick any color from your screen
- **Keyboard Shortcut**: Quick access via ⌘⇧P
- **Instant Add**: Picked colors automatically added to current palette

### 📁 Collections
- **Organize**: Create folders to organize your palettes
- **Manage**: Easy creation and deletion of collections
- **Filter**: View palettes by collection

### 🌓 Dark Mode
- Full support for macOS dark mode
- Automatic theme switching
- Optimized UI for both light and dark appearances

## System Requirements

- macOS 14.0 or later
- 64-bit Intel or Apple Silicon processor

## Installation

1. Download ColorStudio.app from the releases page
2. Move ColorStudio.app to your Applications folder
3. Double-click to launch

For App Store installation:
1. Open the Mac App Store
2. Search for "ColorStudio"
3. Click "Get" or "Buy" ($5.99 USD)

## Usage

### Creating a Palette
1. Click the "+" button in the palette list
2. Name your palette
3. Start adding colors using any of the available methods

### Adding Colors
- Use the color picker (wheel or sliders)
- Extract from images by dragging and dropping
- Generate harmony colors from a base color
- Pick colors from your screen

### Organizing Palettes
1. Create a new collection using the "+" button in the sidebar
2. Assign palettes to collections when creating them
3. Filter palettes by selecting a collection

### Exporting
1. Select a palette
2. Click the "Export" button
3. Choose your desired format
4. Save to your preferred location

## Architecture

ColorStudio is built using modern Swift development practices:

- **SwiftUI**: Modern declarative UI framework
- **AppKit**: Native macOS functionality (color picking, windows)
- **MVVM**: Model-View-ViewModel architecture pattern
- **Core Image**: Advanced image processing for color extraction
- **No External Dependencies**: Pure Swift implementation

## File Structure

```
ColorStudio/
├── ColorStudioApp.swift       # App entry point
├── ContentView.swift           # Main app layout
├── Models/
│   ├── ColorModel.swift        # Color data model with conversions
│   ├── Palette.swift           # Palette data model
│   └── Collection.swift        # Collection data model
├── ViewModels/
│   ├── PaletteViewModel.swift  # Palette management logic
│   └── CollectionViewModel.swift # Collection management logic
├── Views/
│   ├── ColorPickerView.swift   # Main color picker
│   ├── ColorWheelView.swift    # Color wheel implementation
│   ├── ColorSlidersView.swift  # RGB/HSB/CMYK/LAB sliders
│   ├── PaletteListView.swift   # Palette list sidebar
│   ├── PaletteEditorView.swift # Main editing interface
│   ├── CollectionSidebar.swift # Collection organization
│   ├── HarmonyView.swift       # Color harmony generator
│   ├── AccessibilityView.swift # WCAG contrast checker
│   ├── ColorBlindnessView.swift # CVD simulator
│   ├── ExportView.swift        # Export dialog
│   └── ImageDropView.swift     # Image drag & drop
├── Services/
│   ├── ImageColorExtractor.swift    # Color extraction
│   ├── HarmonyGenerator.swift       # Harmony calculations
│   ├── AccessibilityChecker.swift   # WCAG compliance
│   ├── ColorBlindnessSimulator.swift # CVD simulation
│   ├── ExportManager.swift          # Export handlers
│   └── MenuBarColorPicker.swift     # Screen color picker
└── Utilities/
    └── ColorExtensions.swift   # Helper extensions
```

## Privacy

ColorStudio respects your privacy:
- All data is stored locally on your device
- No network connections are made
- No analytics or tracking
- No personal data collection

## Support

For bug reports, feature requests, or questions:
- GitHub Issues: [github.com/lopodragon/colorstudio/issues]
- Email: support@lopodragon.com

## License

ColorStudio is released under the MIT License. See LICENSE file for details.

## Credits

Developed by lopoDragon
Copyright © 2026 lopoDragon. All rights reserved.

## Changelog

See CHANGELOG.md for version history and updates.
