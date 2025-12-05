//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");

// tofu standard imports
const log = std.log;
const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

const testing = std.testing;
const alctr = std.testing.allocator;

// Import of module 'tofu'
pub const tofu = @import("tofu");

// Reactor: The single-threaded, event-driven implementation
// of the Ampe interface. It utilizes the Reactor pattern to multiplex
// non-blocking socket I/O via an internal poll-style loop.
pub const Reactor = tofu.Reactor;

pub const Ampe = tofu.Ampe;

// Contains settings for the internal message pool.
pub const Options = tofu.Options;

// The default configuration options for the pool.
pub const DefaultOptions = tofu.DefaultOptions;

// A grouping mechanism for managing a collection of related channels.
pub const ChannelGroup = tofu.ChannelGroup;

pub const message = tofu.message;

// The core Message structure processed by the engine.
pub const Message = tofu.Message;

// Meta-data for the Message.
// Used internally by the engine for routing and by the application for context.
pub const BinaryHeader = message.BinaryHeader;

pub const status = tofu.status;
// An enum representation of the status byte
// (part of BinaryHeader) for clear status tracking.
pub const AmpeStatus = status.AmpeStatus;
// An error type corresponding to the status above,
// used for conveying failure states.
pub const AmpeError = status.AmpeError;

// Helpers - for convenient injection of socket addresses
// to the message.
pub const configurator = tofu.configurator;
pub const Configurator = configurator.Configurator;

pub fn callTofuHelpers(allocator: Allocator, txt: []const u8) !void {
    std.testing.log_level = .debug;

    const port = try tofu.FindFreeTcpPort();

    log.debug("{s} free TCP/IP port {d}", .{ txt, port });

    var tup: tofu.TempUdsPath = .{};

    const filePath = try tup.buildPath(allocator);

    log.debug("{s} UDS path {s}", .{ txt, filePath });

    return;
}

test "tofu helpers" {
    _ = try callTofuHelpers(std.testing.allocator, "root");
}
