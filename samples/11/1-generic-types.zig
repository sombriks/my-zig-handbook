// 1-generic-types.zig

const std = @import("std");

fn add(T: type, a: T, b: T) T {
    return a + b;
}

pub fn main() void {
    const x = 10;
    const y = 20;
    const z = comptime add(u8, x, y);
    std.log.info("z: {}", .{z});
}
