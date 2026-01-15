# Testing Patterns

**Analysis Date:** 2025-01-14

## Test Framework

**No automated test framework** - This is embedded firmware requiring hardware testing.

**Build Verification:**
- GitHub Actions compiles firmware on every push/PR
- Build failures indicate syntax errors or invalid config
- Successful build produces `.uf2` artifacts

## Test File Organization

**Diagnostic Keymaps:**
- `config/klor_diagnostic.keymap` - Each key sends unique character (A-Z, 0-9)
- `config/klor_test.keymap` - Basic functionality test keymap
- Purpose: Hardware verification, matrix testing

**Location:**
- Test keymaps in `config/` alongside main keymap
- Not used in production builds (main keymap is `config/klor.keymap`)

## Test Structure

**Hardware Diagnostic Test (`klor_diagnostic.keymap`):**
- Single-layer flat layout
- Each key position sends identifying character
- Used to verify every key responds correctly
- Identifies shorts, pin mapping errors, matrix issues

**Basic Test (`klor_test.keymap`):**
- Minimal layer configuration
- Tests basic key responsiveness
- Encoder functionality verification

## Mocking

**Not applicable** - No mocking framework for embedded firmware.

**Hardware Simulation:**
- No ZMK simulator available
- Must test on physical hardware
- Debug builds with USB logging aid troubleshooting

## Fixtures and Factories

**Not applicable** - No test fixtures for firmware testing.

## Coverage

**No automated coverage tracking.**

**Critical paths to manually verify:**
1. Base layer key presses
2. Layer switching (momentary, toggle, tap-dance)
3. Combo activation
4. Encoder rotation and press
5. Bluetooth pairing and switching
6. Power management (sleep/wake)

## Test Types

**Manual Hardware Tests:**
- Key matrix verification using diagnostic keymap
- Layer navigation testing
- Combo timing tests
- Encoder direction and resolution
- Bluetooth connection stability

**Build System Tests:**
- GitHub Actions validates firmware compiles
- Debug builds with `zmk-usb-logging` for runtime inspection

## Common Patterns

**Hardware Verification Workflow:**
1. Flash diagnostic keymap to both halves
2. Test each key produces expected character
3. Identify any non-responsive or incorrect keys
4. Flash main keymap for functionality testing
5. Test each layer and combo

**Debug Build Usage:**
```yaml
# From build.yaml (lines 22-30)
- board: nice_nano_v2
  shield: klor_left
  snippet: zmk-usb-logging
  artifact-name: klor_left_debug
```

**Debug Testing:**
1. Build with USB logging enabled
2. Connect to serial console
3. Observe key events, layer changes, BT status
4. Identify issues from log output

## Run Commands

**Build firmware:**
```bash
# No local build - use GitHub Actions
git push origin main
# Download firmware.zip from Actions artifacts
```

**Flash firmware:**
1. Connect keyboard half to PC
2. Double-press reset button
3. Drag-drop `.uf2` to mass storage device
4. Repeat for other half

## Testing Limitations

**Known ZMK Limitations:**
- Secondary side encoder doesn't work (ZMK limitation)
- No mouse key support yet
- Trackball (Pixart Paw3204) not implemented

**Testing Challenges:**
- No automated testing framework
- Requires physical hardware
- Bluetooth testing needs multiple devices
- Power management testing requires extended time

---

*Testing analysis: 2025-01-14*
*Update when test patterns change*
