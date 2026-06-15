// 2-pointers-and-dynamic-memory.zig

const std = @import("std");
const info = std.log.info;

pub fn main() void {
    // single-item pointers
    var x: i16 = 4;
    var y = &x;
    std.log.info("x: {}, y: {}", .{ x, y.* });
    y.* = 6;
    std.log.info("x: {}, y: {}", .{ x, y.* });
    var z: i16 = 10;
    y = &z;
    std.log.info("x: {}, y: {}, z: {}", .{ x, y.*, z });
    z = 29;
    std.log.info("x: {}, y: {}, z: {}", .{ x, y.*, z });
    // multiple items pointers
    var buffer: [10]i32 = undefined; // surprise values
    var ptr: [*]i32 = &buffer;
    ptr[0] = -11;
    std.log.info("buffer: {any}, \nptr: {*}", .{ buffer, ptr });
    // this one does not compile
    // std.log.info("buffer: {}, \nptr: {any}", .{ buffer.len, (ptr.*).len });
    buffer[1] = 11;
    std.log.info("buffer: {any}, \nptr: {*}", .{ buffer, ptr });
    // slices / fat pointers
    var slice: []i32 = buffer[0..6];
    std.log.info("slice: {any}", .{slice});
    slice[2] = 44;
    std.log.info("buffer: {any}", .{buffer});
    // optional pointer wrapper

}
