// 2-threads.zig

const std = @import("std");

fn work(io: *std.Io, id: usize, n: i64) !void {
    std.log.info("worker {} started", .{id});
    defer std.log.info("worker {} finished", .{id});
    try io.*.sleep(.fromSeconds(n), .awake);
}

pub fn main(init: std.process.Init) !void {
    var io: std.Io = init.io;

    const ReturnType = @typeInfo(@TypeOf(work)).@"fn".return_type.?;
    var futures: [9]std.Io.Future(ReturnType) = undefined;
    for(0..9) |i| {
        const id = i + 1;
        const seconds = @as(i64, @intCast(1 + i % 3));
        futures[i] = io.async(work, .{&io, id, seconds});
    }

    for(&futures) |*future| {
        _ = try future.await(io);
    }
}
