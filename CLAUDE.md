# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a ZMK firmware configuration for the KLOR split keyboard. KLOR is a 36-42 key column-staggered split keyboard that supports per-key RGB matrix, encoders, OLED displays, and a Pixart Paw3204 trackball. The keyboard uses nice!nano v2 controllers and is built using the ZMK firmware framework.

## Build System

### Automated Builds

Firmware is built automatically via GitHub Actions on push, pull request, or manual workflow dispatch. The build process:

1. Triggered automatically when changes are pushed to the repository
2. Uses ZMK's build-user-config workflow (`.github/workflows/build.yml`)
3. Builds based on the board/shield combinations defined in `build.yaml`:
   - `nice_nano_v2` + `klor_left`
   - `nice_nano_v2` + `klor_right`
4. Outputs firmware files as `firmware.zip` in GitHub Actions artifacts:
   - `klor_left-nice_nano_v2-zmk.uf2`
   - `klor_right-nice_nano_v2-zmk.uf2`

### Flashing Firmware

To flash the compiled firmware:
1. Download `firmware.zip` from GitHub Actions artifacts
2. Connect the keyboard half to PC
3. Press reset button twice to enter bootloader mode
4. Drag and drop the corresponding `.uf2` file to the mass storage device
5. Repeat for the other half

## File Structure

### Primary Configuration Files

- `config/klor.keymap` - Main keymap definition with 12 layers
- `config/klor.conf` - Feature configuration (encoders, Bluetooth settings)
- `build.yaml` - Defines which board/shield combinations to build
- `config/west.yml` - West manifest for ZMK project dependencies
- `config/klor.json` - Keymap visualization/documentation (not used by ZMK build)

### Shield Definition

The shield is defined in `config/boards/shields/klor/`:
- `klor_left.overlay` / `klor_right.overlay` - Hardware pin definitions for each half
- `klor_common.dtsi` - Shared device tree configuration
- `klor.dtsi` - Main device tree include
- Custom C files for OLED display implementation (if enabled)

## Keymap Architecture

The keymap (`config/klor.keymap`) uses a sophisticated 12-layer architecture:

### Core Layers (0-2)
- **Layer 0 (BASE)**: QWERTY base layer with layer-tap and momentary layer access
- **Layer 1 (NAV)**: Navigation keys (arrows, home/end, page up/down)
- **Layer 2 (MOUSE)**: Mouse layer (placeholder for future mouse key implementation)

### Gaming Layers (3-5)
- **Layer 3 (GAMING)**: Gaming-optimized layout (WASD positioning)
- **Layer 4 (GAMING2)**: Alternative gaming layout
- **Layer 5 (GAMING3)**: Third gaming layout variant

### Number/Symbol Layers (6-7)
- **Layer 6 (NUMBER)**: Number pad and brackets/parentheses
- **Layer 7 (SYMBOL)**: Shifted number row symbols

### Home Layers (8-9)
- **Layer 8 (HOMELEFT)**: Left-hand modifiers (sticky keys for GUI, Alt, Ctrl, Shift)
- **Layer 9 (HOMERIGHT)**: Right-hand modifiers (mirror of left side)

### System Layers (10-11)
- **Layer 10 (FUNCTION)**: Function keys (F1-F12)
- **Layer 11 (SYSTEM)**: System controls (Bluetooth pairing, bootloader, sys_reset)

### Advanced Features

**Tap Dance Behaviors:**
- `td_nav_mouse`: Single tap activates NAV layer, double tap activates MOUSE layer
- `td_num_sym`: Single tap activates NUMBER layer, double tap activates SYMBOL layer

**Combos:**
- Keys 0+1: ESC
- Keys 1+2+3+38: Activate GAMING layer (from BASE layer only)
- Keys 11+12: TAB (BASE layer only)
- Keys 23+24: Grave/backtick (BASE layer only)
- Keys 19+20: Single quote
- Keys 31+32: Dash/minus
- Keys 41+38: Reset to layer 0
- Keys 39+22: Jump to SYSTEM layer

**Macros:**
- `delete`: Shift+Backspace
- `alt_tab`: Alt+Tab sequence

**Layer-Tap Keys:**
- Z key: Hold for SYSTEM layer (11), tap for Z
- B key: Hold for FUNCTION layer (10), tap for B

## Feature Configuration

Current settings in `config/klor.conf`:
- **NFC pins as GPIOs**: Critical for nice!nano v2 compatibility
- **Encoders**: EC11 support enabled
- **Bluetooth**: Enhanced TX power (+8dBm), supports 6 concurrent connections and 6 paired devices
- **Behavior queue**: Increased to 512 for complex layer-tap/hold-tap behaviors
- **Display/RGB**: Currently disabled (can be enabled by uncommenting in shield conf files)

## Layer Navigation Strategy

The keymap uses multiple access patterns:
- **Tap-dance** on thumb keys for quick layer switching
- **Momentary layers** (`mo`) for temporary access
- **Layer-tap** (`lt`) on home row keys for dual-purpose keys
- **Sticky keys** (`sk`) in home layers for one-shot modifiers
- **Combos** for quick access to gaming and system layers

## Known Limitations

- Secondary side encoder doesn't work (ZMK limitation)
- Pixart Paw3204 trackball code not yet implemented
- OLED and RGB features currently disabled

## ZMK Documentation

Refer to https://zmk.dev/docs for:
- Keycodes reference
- Behavior configuration (tap-dance, hold-tap, sticky keys)
- Device tree syntax
- Combo and macro configuration
