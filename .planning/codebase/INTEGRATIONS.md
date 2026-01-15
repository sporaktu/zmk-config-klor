# External Integrations

**Analysis Date:** 2025-01-14

## APIs & External Services

**Not applicable** - This is embedded firmware with no external API dependencies.

## Data Storage

**Not applicable** - Firmware runs on microcontroller with no persistent storage requirements beyond flash memory.

## Authentication & Identity

**Not applicable** - No authentication required for keyboard firmware.

## Monitoring & Observability

**Debug Logging:**
- USB logging via `zmk-usb-logging` snippet
- Debug builds configured in `build.yaml` (lines 22-30)
- ZMK log level configurable via `CONFIG_ZMK_LOG_LEVEL`

**No external monitoring services** - Standalone embedded device.

## CI/CD & Deployment

**Hosting:**
- GitHub repository for source code
- GitHub Actions for firmware builds
- Firmware distributed as artifacts

**CI Pipeline:**
- GitHub Actions - `.github/workflows/build.yml`
- Uses official ZMK workflow: `zmkfirmware/zmk/.github/workflows/build-user-config.yml@v0.3.0`
- Triggers: push, pull_request, workflow_dispatch
- Artifacts: `firmware.zip` with `.uf2` files

**Build Matrix (`build.yaml`):**
```yaml
include:
  - board: nice_nano_v2
    shield: klor_left
  - board: nice_nano_v2
    shield: klor_right
  - board: nice_nano_v2
    shield: settings_reset
```

## ZMK Dependencies

**ZMK Firmware Core:**
- Remote: `https://github.com/zmkfirmware`
- Version: **v0.3.0** (pinned in `config/west.yml`)
- Provides: Keyboard behaviors, device tree support, Bluetooth/USB protocols

**Zephyr RTOS Libraries:**
- Kernel API: `<kernel.h>`
- Bluetooth: `<bluetooth/services/bas.h>`
- Logging: `<logging/log.h>`
- USB: `<zmk/usb.h>`
- Event system: `<zmk/event_manager.h>`

**Display Libraries (disabled):**
- LVGL: `<lvgl.h>` for OLED rendering
- ZMK Display: `<zmk/display.h>`, `<zmk/display/widgets/*.h>`

## Hardware Integration

**Primary Controller:**
- nice!nano v2 (nRF52840 MCU)
- Pro Micro footprint
- Overlay: `config/boards/shields/klor/boards/nice_nano_v2.overlay`

**Alternative Controllers:**
- nRFmicro_11: `config/boards/shields/klor/boards/nrfmicro_11.overlay`
- nRFmicro_13: `config/boards/shields/klor/boards/nrfmicro_13.overlay`

**Peripheral Hardware:**
- EC11 Rotary Encoders: Defined in `config/boards/shields/klor/klor.dtsi`
- Switch Matrix: 12 columns × 4 rows (42-key layout)
- OLED Display: SSD1306 (code exists, feature disabled)
- RGB Underglow: WS2812B (commented out in nice_nano_v2.overlay)
- Trackball: Pixart Paw3204 (not yet implemented)

## Deployment Pipeline

**Build Flow:**
```
Push to GitHub
→ GitHub Actions triggers build.yml
→ Uses ZMK v0.3.0 build-user-config workflow
→ Matrix build: nice_nano_v2 + klor_left/right
→ Outputs firmware.zip as artifact
```

**Flashing Process:**
1. Download firmware.zip from GitHub Actions artifacts
2. Connect keyboard half to PC
3. Double-press reset button (bootloader mode)
4. Appears as mass storage device
5. Drag-drop .uf2 file to device
6. Repeat for other half

## Webhooks & Callbacks

**Not applicable** - No webhooks for embedded firmware.

---

*Integration audit: 2025-01-14*
*Update when adding/removing external services*
