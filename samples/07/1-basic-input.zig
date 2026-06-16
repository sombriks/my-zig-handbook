// 1-basic-input.zig
const std = @import("std");

pub fn main(init: std.process.Init) void {
    const name = init.environ_map.get("USER") orelse "stranger";
    std.log.info("hello, {s}!",.{name} );
}
