# Technology Stack

**Analysis Date:** 2025-01-14

## Languages

**Primary:**
- Device Tree Source (DTS/DTSI/overlay) - Hardware configuration
- ZMK Keymap DSL - Behavioral definitions and key bindings

**Secondary:**
- C - Custom OLED display widgets (`config/boards/shields/klor/*.c`)
- YAML - Build and dependency configuration
- Kconfig (.conf) - Feature flags and settings

## Runtime

**Environment:**
- Zephyr RTOS - Real-time operating system for embedded devices
- nRF52840 MCU (ARM Cortex-M4) - On nice!nano v2 controller
- Bluetooth 5.0 stack

**Package Manager:**
- West - Zephyr/ZMK package manager
- Version defined in `config/west.yml`

## Frameworks

**Core:**
- ZMK Firmware v0.3.0 - Split keyboard firmware framework
- Zephyr RTOS - Underlying operating system

**Build/Dev:**
- GitHub Actions - Automated CI/CD builds
- ZMK build-user-config workflow

**Graphics:**
- LVGL - Light and Versatile Graphics Library (for OLED, currently disabled)

## Key Dependencies

**Critical:**
- ZMK v0.3.0 - Keyboard behaviors, Bluetooth/USB protocols (`config/west.yml`)
- Zephyr kernel - RTOS core (`<kernel.h>`)
- Device Tree bindings - Hardware abstraction (`<dt-bindings/zmk/*.h>`)

**Infrastructure:**
- EC11 encoder support - `CONFIG_EC11=y` in `config/klor.conf`
- Bluetooth services - `<bluetooth/services/bas.h>` for battery

## Configuration

**Environment:**
- No environment variables required
- Configuration via Kconfig files:
  - `config/klor.conf` - Global features (power, BT, NFC pins)
  - `config/boards/shields/klor/klor.conf` - Shield features (encoders)

**Build:**
- `build.yaml` - Build matrix (board/shield combinations)
- `config/west.yml` - ZMK dependency manifest
- `.github/workflows/build.yml` - CI workflow

**Key Config Settings:**
- `CONFIG_NFCT_PINS_AS_GPIOS=y` - Critical for nice!nano v2
- `CONFIG_BT_MAX_CONN=6` - Bluetooth connections
- `CONFIG_ZMK_BEHAVIORS_QUEUE_SIZE=512` - Complex behavior support
- `CONFIG_ZMK_IDLE_SLEEP_TIMEOUT=7200000` - 2 hour deep sleep

## Platform Requirements

**Development:**
- Any platform with Git and GitHub Actions access
- No local build required (GitHub Actions builds firmware)

**Production:**
- nice!nano v2 controller (primary)
- Alternative controllers: nRFmicro_11, nRFmicro_13
- UF2 bootloader for firmware flashing
- Firmware deployed via mass storage device mode

**Build Output:**
- `firmware.zip` containing `.uf2` files:
  - `klor_left-nice_nano_v2-zmk.uf2`
  - `klor_right-nice_nano_v2-zmk.uf2`

---

*Stack analysis: 2025-01-14*
*Update after major dependency changes*
