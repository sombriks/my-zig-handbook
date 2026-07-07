// 3-error-handling.zig

const std = @import("std");

pub fn main(init: std.process.Init) void {
    const stdin = std.Io.File.stdin();
    defer stdin.close(init.io);
    var buffer: [1024]u8 = @splat(0);
    const bytesRead = stdin.readStreaming(init.io, &.{&buffer}) catch |err| {
        std.log.err("this shouldn't happen: {any}", .{err});
        return; // end the function here
    };
    std.log.info("Returned tytpe: {any}", .{@TypeOf(bytesRead)});
    std.log.info("Returned value: {any}", .{bytesRead});
    std.log.info("Bytes in the buffer {s}", .{buffer});
}
