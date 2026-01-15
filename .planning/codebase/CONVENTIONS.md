# Coding Conventions

**Analysis Date:** 2025-01-14

## Naming Patterns

**Files:**
- Snake_case for shield files: `klor_left.overlay`, `klor_right.overlay`
- Kebab-case for docs: `readme.md`, `CLAUDE.md`
- Uppercase for important files: `CLAUDE.md`

**Layers (defined in `config/klor.keymap`):**
- Uppercase constants: `BASE`, `NAV`, `MOUSE`, `GAMING`, `NUMBER`, `SYMBOL`
- Descriptive names: `HOMELEFT`, `HOMERIGHT`, `FUNCTION`, `SYSTEM`
- Suffixes for variants: `BASE_MAC`, `HOMELEFT_MAC`
- Pattern: `#define LAYER_NAME N` (0-14)

**Behaviors:**
- Tap-dance: `td_` prefix + descriptive name: `td_nav_mouse`, `td_num_sym`, `td_enc_media`
- Macros: Short descriptive names: `delete`, `alt_tab`
- Labels: Uppercase in quotes: `label = "TD_NAV_MOUSE";`

**Combos:**
- Lowercase with underscores: `combo_esc`, `reset_layers`, `activate_gaming`
- Action-oriented names: `quote`, `dash`, `tab`, `escape`

**Device Tree:**
- Snake_case for nodes: `left_encoder`, `right_encoder`, `kscan0`
- Ampersand references: `&pro_micro`, `&left_encoder`

## Code Style

**Formatting (Device Tree):**
- Tab indentation (tabs, not spaces)
- Opening brace on same line: `node_name {`
- Multi-line arrays with leading comma:
  ```dts
  col-gpios
      = <&pro_micro 19 GPIO_ACTIVE_HIGH>
      , <&pro_micro 18 GPIO_ACTIVE_HIGH>
      ;
  ```

**Formatting (Keymap):**
- Tab alignment for key bindings
- ASCII art dividers between sections (using █, ▄, ▀ characters)
- Visual layout diagrams in comments

**Formatting (YAML):**
- 2 space indentation
- Inline comments for documentation

**Formatting (Config):**
- `CONFIG_KEY=value` format
- Comment sections with `#` prefix
- Descriptive comments explaining purpose

## Import Organization

**Keymap Includes (order in `config/klor.keymap`):**
1. Core behaviors: `#include <behaviors.dtsi>`
2. Key bindings: `#include <dt-bindings/zmk/keys.h>`
3. Bluetooth: `#include <dt-bindings/zmk/bt.h>`
4. Output: `#include <dt-bindings/zmk/outputs.h>`
5. Features: `#include <dt-bindings/zmk/ext_power.h>`

**Device Tree Includes:**
- Matrix transform: `#include <dt-bindings/zmk/matrix_transform.h>`
- LED bindings: `#include <dt-bindings/led/led.h>` (when RGB enabled)

## Error Handling

**Patterns:**
- Invalid references cause compile-time errors
- No runtime error handling (embedded firmware)
- Reset combos for recovery

**Device Tree:**
- `status = "disabled";` to disable unused hardware
- Commented blocks for optional features

## Logging

**Framework:**
- ZMK logging via `CONFIG_ZMK_LOG_LEVEL`
- USB logging snippet for debug builds

**Patterns:**
- Debug builds separate in `build.yaml`
- No logging in production firmware

## Comments

**When to Comment:**
- Explain hardware pin assignments
- Document layer purpose and key positions
- Note disabled features and why

**Documentation Style:**
- ASCII art layout diagrams in keymaps
- Copyright headers with SPDX license
- Inline comments for non-obvious config

**Comment Formats:**
- Device tree: `/* block comment */` or `// line comment`
- Keymap: ASCII art dividers + inline comments
- Config: `# comment` prefix

## Function Design

**Behavior Definitions:**
- One behavior per block
- Label matches behavior name
- Standard tapping-term: 200ms for tap-dance

**Layer Definitions:**
- Label matches layer define
- Sensor-bindings for encoder support
- All 42 key positions defined (even if `&trans`)

## Module Design

**Shield Organization:**
- Base device tree (`klor.dtsi`) defines common hardware
- Left/right overlays extend with GPIO specifics
- Controller overlays for board-specific features

**Config Hierarchy:**
- Global config: `config/klor.conf`
- Shield config: `config/boards/shields/klor/klor.conf`
- Per-side config: `klor_left.conf`, `klor_right.conf`

**Keymap Organization:**
- Preprocessor defines at top
- Behaviors and combos before keymap
- Layers in logical groups (base, navigation, gaming, modifiers, system)

---

*Convention analysis: 2025-01-14*
*Update when patterns change*
