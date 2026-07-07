// 1-error-handling.zig

const std = @import("std");

pub fn main(init: std.process.Init) void {
    const stdin = std.Io.File.stdin();
    defer stdin.close(init.io);
    var buffer: [1024]u8 = @splat(0);
    const errorOrBytesRead = stdin.readStreaming(init.io, &.{&buffer});
    std.log.info("Returned tytpe: {any}", .{@TypeOf(errorOrBytesRead)});
    std.log.info("Returned value: {any}", .{errorOrBytesRead});
    std.log.info("Bytes in the buffer {s}", .{buffer});
    // to properly access the returned value, if successful, inwrap it:
    if (errorOrBytesRead) |bytesRead| {
        const minusLineBreak = bytesRead - 1;
        std.log.info("bytes read: {}", .{minusLineBreak});
    } else |err| std.log.info("Something went wrong: {}", .{err});
}
