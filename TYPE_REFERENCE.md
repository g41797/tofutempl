# Type Reference for tofutempl Project

## Common Types Used in Project

### From tofu Module
- `Reactor` - Single-threaded event-driven implementation of Ampe interface
- `Ampe` - Core engine interface
- `Options` - Settings for internal message pool
- `DefaultOptions` - Default configuration for pool
- `ChannelGroup` - Grouping mechanism for managing related channels
- `Message` - Core message structure processed by engine
- `BinaryHeader` - Meta-data for Message
- `AmpeStatus` - Enum representation of status byte
- `AmpeError` - Error type for failure states
- `Configurator` - Helper for socket address injection

### Standard Library Types
- `std.mem.Allocator` - Memory allocator interface
- `std.Thread` - Thread type
- `[]const u8` - String/byte slice (const)
- `[]u8` - Mutable byte slice
- `u8` - Unsigned 8-bit integer
- `u16` - Unsigned 16-bit integer
- `u32` - Unsigned 32-bit integer

### Pointer Types
- `*Reactor` - Pointer to Reactor
- `?*Message` - Optional pointer to Message
- `*tofu.TempUdsPath` - Pointer to temporary UDS path helper

### Function Return Types
- `!void` - Error union returning void
- `!u16` - Error union returning u16 (e.g., port number)
- `![]u8` - Error union returning byte slice

## Type Mapping for Variables

### From src/root.zig
```zig
// Function: callTofuHelpers
allocator: Allocator           // Parameter type
txt: []const u8                // Parameter type
port: u16                      // Return from FindFreeTcpPort()
tup: tofu.TempUdsPath         // Struct instance
filePath: []u8                 // Return from buildPath()
```

### From src/main.zig
```zig
// Function: main
dbalctr: std.heap.DebugAllocator(.{})  // Debug allocator instance
gpa: Allocator                 // Allocator from dbalctr.allocator()
```

## Notes
- All pointers should use explicit dereference: `ptr.*` instead of implicit
- All variable declarations should have explicit type annotations
- Preserve all existing comments and functionality
