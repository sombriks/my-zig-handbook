// src/main.zig

const std = @import("std");
const my_zig_c = @import("my_zig_c");

pub fn main(_: std.process.Init) void {
    std.log.info("All your {s} are belong to us.", .{"codebase"});
    const result = my_zig_c.c.my_function(20, 22);
    std.log.info("The result of my_function(20, 22) is {d}", .{result});
}
