// 1-modules-and-functions.zig
const std = @import("std");

pub fn main() void {
    // import a module
    const Module1 = @import("my-function.zig");
    const add = Module1.add;

    std.log.info("type of add: {}", .{@TypeOf(add)});
    std.log.info("add 2+3: {}", .{add(2,3)});

    const Module2 = @import("./my-struct.zig");
    const p1: Module2.Player = .{};

    std.log.info("type of p1: {}", .{@TypeOf(p1)});

    const Player = Module2.Player;
    const p2: Player = undefined;

    std.log.info("type of p2: {}", .{@TypeOf(p2)});

    // this does not compile at all
    // const hidden = Module1.hidden;
}
