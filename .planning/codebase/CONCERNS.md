# Codebase Concerns

**Analysis Date:** 2025-01-14

## Tech Debt

**Untracked backup/test files:**
- Issue: Multiple keymap variants cluttering repository
- Files: `config/klor.keymap.backup`, `config/klor_diagnostic.keymap`, `config/klor_test.keymap`, `config/boards/shields/klor/klor.keymap.old`
- Why: Experimental development, incomplete cleanup
- Impact: Repository confusion, unclear which files are authoritative
- Fix approach: Remove or commit with clear documentation of purpose

**Legacy QMK configuration:**
- Issue: Entire QMK firmware directory left in repo
- Files: `qmk_keymap/` directory (keymap.c, config.h, rules.mk)
- Why: Project migrated from QMK to ZMK
- Impact: Users may accidentally try to use QMK config
- Fix approach: Remove `qmk_keymap/` directory entirely

**Duplicate encoder configuration:**
- Issue: Same encoder settings in two config files
- Files: `config/klor.conf` and `config/boards/shields/klor/klor.conf`
- Why: Unclear separation of concerns
- Impact: Maintenance burden, potential inconsistency
- Fix approach: Consolidate to single location

## Known Bugs

**None identified** - Firmware appears stable.

## Security Considerations

**Not applicable** - Embedded keyboard firmware with no network attack surface.

## Performance Bottlenecks

**Large behavior queue:**
- Problem: `CONFIG_ZMK_BEHAVIORS_QUEUE_SIZE=512` may indicate complex behavior chains
- File: `config/klor.conf`
- Measurement: Not benchmarked (embedded timing)
- Cause: 15-layer architecture with tap-dance and combos
- Improvement path: Simplify layer architecture if latency issues observed

## Fragile Areas

**15-layer architecture:**
- File: `config/klor.keymap` (410 lines)
- Why fragile: Complex layer interaction, many access paths
- Common failures: Unintended layer switches, stuck modifiers
- Safe modification: Test all layer transitions after changes
- Test coverage: Manual testing only

**Combo system:**
- File: `config/klor.keymap` (lines 91-166)
- Why fragile: 12+ combos with overlapping key positions
- Common failures: Accidental combo activation during fast typing
- Safe modification: Document combo positions, test timing

**macOS layer duplication:**
- Files: `config/klor.keymap` (lines 370-408) - BASE_MAC, HOMELEFT_MAC, HOMERIGHT_MAC
- Why fragile: Changes to base layers must be mirrored
- Common failures: Forgetting to update macOS variants
- Safe modification: Consider programmatic layer inheritance

## Scaling Limits

**Not applicable** - Single-device embedded firmware.

## Dependencies at Risk

**ZMK version pinned:**
- File: `config/west.yml` (revision: v0.3.0)
- Risk: Missing security fixes and new features
- Impact: No mouse key support, trackball support limited
- Migration plan: Update to newer ZMK version when needed

## Missing Critical Features

**Mouse layer non-functional:**
- Problem: Layer 2 (MOUSE) contains only transparent keys
- File: `config/klor.keymap` (lines 230-240)
- Current workaround: None - layer exists but does nothing
- Blocks: Mouse control from keyboard
- Implementation complexity: Low - ZMK mouse keys exist, just need binding

**Trackball not implemented:**
- Problem: Pixart Paw3204 trackball hardware support missing
- File: `readme.md`, `CLAUDE.md` document this limitation
- Current workaround: External mouse
- Blocks: Full hardware utilization
- Implementation complexity: High - requires driver development

**Right encoder disabled:**
- Problem: Secondary side encoder doesn't work
- File: `config/boards/shields/klor/klor.dtsi` (line 57: `status = "disabled"`)
- Current workaround: Use left encoder only
- Blocks: Right-hand encoder functionality
- Implementation complexity: Blocked by ZMK limitation

**RGB underglow disabled:**
- Problem: WS2812B LED support commented out
- File: `config/boards/shields/klor/boards/nice_nano_v2.overlay` (lines 1-50)
- Current workaround: None
- Blocks: RGB lighting effects
- Implementation complexity: Low - uncomment and configure chain-length

**OLED displays disabled:**
- Problem: Display code exists but feature not enabled
- Files: `config/boards/shields/klor/*_status.c/h`, `icons/*.c`
- Current workaround: None
- Blocks: Status display on keyboard
- Implementation complexity: Low - enable in config

## Test Coverage Gaps

**No automated testing:**
- What's not tested: All functionality
- Risk: Regressions undetected until manual testing
- Priority: Low (firmware projects typically lack automated tests)
- Difficulty to test: High - requires hardware simulation

**Layer interaction not systematically tested:**
- What's not tested: All 15 layer combinations and transitions
- Risk: Stuck layers, unexpected behavior
- Priority: Medium
- Difficulty to test: Manual testing matrix is large (15! combinations)

---

*Concerns audit: 2025-01-14*
*Update as issues are fixed or new ones discovered*
