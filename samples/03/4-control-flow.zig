// 4-control-flow.zig

const std = @import("std");

pub fn main() void {
    // loop over ranges
    for (0..3) |i| {
        std.log.info("i: {}",.{i});
    }
    // loop over collections
    const names = [_][]const u8{"a","b","c","banana"};
    for(names) |name| {
        std.log.info("name: {s}",.{name});
    }
    // multiple collections
    const integers = [_]u16{1,6,33,9,2,567};
    const floats = [_]f16{1.1,6.4,-33.555,9.1,-2.1111,567.8};
    for(integers,floats) |i,f| {
        std.log.info("numbers: [{}] [{}]",.{i,f});
    }
    // collections and ranges
    for(names,0..) |name, i| {
        std.log.info("i, name: [{}]: [{s}]",.{i,name});
    }
    // pointer to collection change
    var samples = [_]i32{ 1, 1, 1, 1, 1 };
    for(&samples) |*sample| {
        sample.* *= 2;
    }
    std.log.info("Modified array: {any}", .{samples});
    // for loop expression (break to value)
    const x = for(11..111) |i| {
        if (i % 31 == 0) break i;

    } else 123;
    std.log.info("x: {}", .{x});
}
