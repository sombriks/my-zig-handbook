// 2-error-handling.zig

const std = @import("std");

pub fn main(init: std.process.Init) void {
    const stdin = std.Io.File.stdin();
    defer stdin.close(init.io);
    var buffer = [_]u8{0} ** 1024;
    const bytesRead = stdin.readStreaming(init.io, &.{&buffer}) catch unreachable;
    std.log.info("Returned tytpe: {any}", .{@TypeOf(bytesRead)});
    std.log.info("Returned value: {any}", .{bytesRead});
    std.log.info("Bytes in the buffer {s}", .{buffer});
}
