// 1-sample-types.zig

pub fn main() u8 {
    const std = @import("std"); // valid code!
    var x: u8 = 255;
    std.log.debug("x value: {}", .{x});
    std.log.debug("x type: {}", .{@TypeOf(x)});// reflection!
    std.log.debug("x size: {}", .{@sizeOf(u8)}); // size in bytes
    x +%= 1; // overflow-aware add operator
    // a bigger variable
    var y: i16 = 255;
    std.log.debug("y value: {}", .{y});
    std.log.debug("y type: {}", .{@TypeOf(y)});
    std.log.debug("y size: {}", .{@sizeOf(i16)});
    y += 1; // no need to worry about overflows for now
    std.log.debug("y value: {}", .{y});
    // now some jazz
    var z: u3 = 0;
    std.log.debug("z value: {}", .{z});
    std.log.debug("z type: {}", .{@TypeOf(z)});
    std.log.debug("z size: {}", .{@sizeOf(u3)});
    z +%= 1;
    std.log.debug("z value: {}", .{z});
    z +%= 2;
    std.log.debug("z value: {}", .{z});
    z +%= 4;
    std.log.debug("z value: {}", .{z});
    z +%= 6;
    std.log.debug("z value: {}", .{z}); // surprise!
    return x; // returns 0
}
