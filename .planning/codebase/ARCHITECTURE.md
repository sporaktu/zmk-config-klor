# Architecture

**Analysis Date:** 2025-01-14

## Pattern Overview

**Overall:** ZMK Firmware Configuration Repository (Split Keyboard)

**Key Characteristics:**
- Device tree-based hardware abstraction
- Split keyboard with left/right shield halves
- 15-layer keymap with tap-dance and combo behaviors
- GitHub Actions automated builds

## Layers

**Hardware Abstraction Layer:**
- Purpose: Define GPIO pins, matrix, encoders for each controller
- Contains: Device tree files (`.dtsi`, `.overlay`)
- Location: `config/boards/shields/klor/`
- Key files:
  - `klor.dtsi` - Matrix transform, encoder definitions
  - `klor_left.overlay` - Left half GPIO column pins
  - `klor_right.overlay` - Right half GPIO pins + col-offset
  - `boards/nice_nano_v2.overlay` - Controller-specific overrides

**Configuration Layer:**
- Purpose: Enable/disable features, set parameters
- Contains: Kconfig files (`.conf`)
- Location: `config/klor.conf`, `config/boards/shields/klor/klor.conf`
- Depends on: Hardware abstraction layer
- Used by: Build system for feature compilation

**Keymap Layer:**
- Purpose: Define key behaviors, layers, combos, macros
- Contains: ZMK keymap DSL (`.keymap`)
- Location: `config/klor.keymap`
- Depends on: Hardware and configuration layers
- Used by: ZMK firmware at runtime

## Data Flow

**Key Press Processing:**

1. GPIO matrix scan detects key press (`kscan0` in `klor.dtsi`)
2. Key position mapped via `default_transform` (4 rows × 12 columns)
3. Current active layer determines key binding
4. Behaviors applied (tap-dance, hold-tap, combos, macros)
5. Output sent to host via Bluetooth or USB

**State Management:**
- Layer state maintained in ZMK runtime
- Bluetooth profiles stored in controller flash
- No persistent user state

## Key Abstractions

**Shield:**
- Purpose: Split keyboard hardware definition
- Examples: `klor_left`, `klor_right`
- Pattern: Overlay files extend base device tree

**Device Tree Hierarchy:**
```
klor.dtsi (matrix transform, encoders, kscan)
├── klor_left.overlay (left GPIO pins, enable left encoder)
└── klor_right.overlay (right GPIO pins, col-offset=6)
    └── boards/nice_nano_v2.overlay (controller SPI/RGB)
```

**Behaviors:**
- Purpose: Encapsulate key actions
- Examples: `td_nav_mouse`, `td_num_sym`, `delete` macro
- Pattern: Defined in keymap, referenced by key positions

**Layer:**
- Purpose: Complete key binding set for a context
- Examples: BASE (0), NAV (1), GAMING (3), SYSTEM (11)
- Pattern: 15 discrete layers accessed via momentary/toggle/tap-dance

## Entry Points

**Main Keymap:**
- Location: `config/klor.keymap`
- Triggers: Firmware build via GitHub Actions
- Responsibilities: Define all layers, behaviors, combos, macros

**Build Configuration:**
- Location: `build.yaml`
- Triggers: Push/PR to repository
- Responsibilities: Define board/shield combinations

**West Manifest:**
- Location: `config/west.yml`
- Triggers: Build initialization
- Responsibilities: Pin ZMK version (v0.3.0)

## Error Handling

**Strategy:** Firmware is resilient - invalid keys produce no output

**Patterns:**
- Invalid layer references compile-time error
- Combos with invalid positions silently ignored
- Reset key combination restores default state

## Cross-Cutting Concerns

**Power Management:**
- Idle timeout: 30 seconds
- Deep sleep: 2 hours
- Wake from deep sleep via key press
- Config: `CONFIG_ZMK_SLEEP=y`, `CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=7200000`

**Bluetooth:**
- 6 concurrent connections
- 6 paired devices
- Enhanced TX power (+8dBm)
- Config: `CONFIG_BT_MAX_CONN=6`, `CONFIG_BT_CTLR_TX_PWR_PLUS_8=y`

**Encoders:**
- EC11 rotary encoder support
- Resolution: 4 pulses per detent
- Left encoder enabled, right disabled (ZMK limitation)

---

*Architecture analysis: 2025-01-14*
*Update when major patterns change*
