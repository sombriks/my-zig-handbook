// 1-threads.zig
const std = @import("std");

fn work(io: *std.Io, id: usize, n: i64) !void {
    std.log.info("worker {} started", .{id});
    defer std.log.info("worker {} finished", .{id});
    try io.*.sleep(.fromSeconds(n), .awake);
}

pub fn main(init: std.process.Init) !void {
    var io: std.Io = init.io;

    // synchronous
    std.log.info("synchronous mode",.{});
    for (1..10) |i| {
        try work(&io, i, @as(i64, @intCast(1 + i % 3)));
    }

    // spawn threads instead
    std.log.info("threaded mode",.{});
    var threads: [9]std.Thread = undefined;
    for (1..10) |i| {
        const id = i;
        const seconds = @as(i64, @intCast(1 + i % 3));
        threads[i - 1] = try std.Thread.spawn(
            .{.allocator = init.gpa},
            work,
            .{&io, id, seconds }
        );
    }

    // wait until the last one to end
    for (threads) |thread| {
        thread.join();
    }
}
