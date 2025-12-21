# Zig 0.14.1 to 0.15.2 Migration Summary

## Migration Date
December 21, 2025

## Zig Version Verification
✓ Confirmed Zig version: **0.15.2**

## Files Modified

### 1. build.zig.zon
**Status:** ✓ Completed

**Changes:**
- Line 10: Updated `minimum_zig_version` from `"0.14.1"` to `"0.15.2"`
- Lines 14-15: Updated tofu dependency commit hash and package hash
  - Old commit: `1c82098d9c2f468d563f3bbcebc13a5a1e641322` (Zig 0.14.1)
  - Final commit: `0a3ea201be2050e43a8875f99c0c2635631e84f9` (Zig 0.15.2, Dec 21, 2025)
  - Old hash: `tofu-0.0.0-vHqBNW1qAwAFEoDh9PhuqUn1x1jW8UPI8yIp_CD9CKTU`
  - Final hash: `tofu-0.0.0-W094V8F3AwAJLueIlLQdq67W1GfMybR_rJMRyfyITf7H`

**Verification:** ✓ Syntax validated with `zig ast-check`

### 2. build.zig
**Status:** ✓ No changes required

**Analysis:**
- Already uses Zig 0.15.x build API patterns:
  - `b.createModule()` with `.root_source_file = b.path(...)`
  - `b.addLibrary(.{ .linkage = .static, .root_module = ... })`
  - `b.addExecutable(.{ .root_module = ... })`
  - `b.addTest(.{ .root_module = ... })`

**Verification:** ✓ Syntax validated with `zig ast-check`

### 3. src/main.zig
**Status:** ✓ No changes required

**Analysis:**
- Uses `std.heap.DebugAllocator(.{}).init` - compatible with 0.15.2
- All imports and code patterns are compatible

**Verification:** ✓ Syntax validated with `zig ast-check`

### 4. src/root.zig
**Status:** ✓ No changes required

**Analysis:**
- All re-exports and helper functions are compatible
- No breaking changes detected

**Verification:** ✓ Syntax validated with `zig ast-check`

## Breaking Changes Research

### Major Changes in Zig 0.15.x:
1. **ArrayList** - Now unmanaged by default, old `std.ArrayList` → `std.array_list.Managed`
2. **Reader/Writer** - Complete I/O interface overhaul ("Writergate")
3. **Format strings** - `{}` → `{f}` for format methods, `{any}` to skip
4. **Build system** - `root_source_file` → `root_module` pattern
5. **Module exposure** - Dependencies must use `b.addModule()` not just `b.createModule()`

## Dependency Issue (Resolved)

### Issue Identified
The tofu dependency initially had an **incomplete 0.15.2 migration** in its build.zig.

### Root Cause
During tofu's initial migration to 0.15.2, the module exposure pattern was incorrectly changed:

**0.14.1 version (working):**
```zig
const tofuMod = b.addModule("tofu", .{
    .root_source_file = b.path("src/tofu.zig"),
    .target = target,
    .optimize = optimize,
    .single_threaded = false,
});
```

**0.15.2 version (broken):**
```zig
const tofuMod = b.*.createModule(.{
    .root_source_file = b.*.path("src/tofu.zig"),
    .target = target,
    .optimize = optimize,
    .single_threaded = false,
});
```

### Impact
- `createModule()` creates internal modules only
- `addModule()` creates AND exposes modules for dependencies
- Without `addModule()`, dependent projects cannot access `tofu.module("tofu")`

### Error Message
```
thread 22194 panic: unable to find module 'tofu'
/home/g41797/dev/langs/zig-x86_64-linux-0.15.2/lib/std/Build.zig:1914:18
build.zig:37:42: lib_mod.addImport("tofu", tofu.module("tofu"));
```

## Resolution

**Fix Applied (in tofu repository):**

Commit: `0a3ea201be2050e43a8875f99c0c2635631e84f9` - "Export tofu as external module"

**File:** tofu/build.zig
**Line:** 37

**Change:**
```zig
-   const tofuMod = b.*.createModule(.{
+   const tofuMod = b.*.addModule("tofu", .{
```

This change properly exposes the "tofu" module for dependent projects.

## Validation Results

### Build Test
```bash
$ zig build
```
✓ **SUCCESS** - No errors, library and executable built successfully

### Unit Tests
```bash
$ zig build test
```
✓ **SUCCESS** - All tests passed
```
[default] (debug): root free TCP/IP port 36891
[default] (debug): root UDS path /tmp/tofuykemh3gYy1c.port
```

### Runtime Test
```bash
$ zig build run
```
✓ **SUCCESS** - Executable runs correctly
```
debug: main free TCP/IP port 46839
debug: main UDS path /tmp/tofuBaYf0UyfXZQ.port
```

## Migration Status

| Task | Status |
|------|--------|
| Zig version verification | ✓ Complete |
| build.zig.zon update | ✓ Complete |
| build.zig verification | ✓ Complete |
| src/main.zig verification | ✓ Complete |
| src/root.zig verification | ✓ Complete |
| Dependency fix (tofu) | ✓ Complete |
| Dependency update | ✓ Complete |
| Build test | ✓ Complete |
| Unit tests | ✓ Complete |
| Runtime test | ✓ Complete |

## Summary

**Migration Status:** ✅ **COMPLETE**

The tofutempl project has been successfully migrated from Zig 0.14.1 to Zig 0.15.2. All source files were already compatible with 0.15.2 API patterns. The only required changes were:

1. Updating `build.zig.zon` minimum version to 0.15.2
2. Updating tofu dependency to 0.15.2-compatible version (commit `0a3ea201`)
3. Fixing tofu's build.zig to properly expose modules (done in tofu repository)

All builds, tests, and runtime execution complete successfully.

## Sources
- [Zig 0.15.1 Release Notes](https://ziglang.org/download/0.15.1/release-notes.html)
- [Zig 0.15 Migration Roadblocks Blog](https://sngeth.com/zig/systems-programming/breaking-changes/2025/10/24/zig-0-15-migration-roadblocks/)
- [Mailbox Migration Discussion](https://ziggit.dev/t/mailbox-migrated-to-0-15-2/13590)
