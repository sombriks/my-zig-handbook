// 3-threads.zig

const std = @import("std");

fn work(io: *std.Io, id: usize, n: i64) !void {
    std.log.info("worker {} started", .{id});
    defer std.log.info("worker {} finished", .{id});
    try io.*.sleep(.fromSeconds(n), .awake);
}

fn scheduler(io: *std.Io) anyerror!void {
    const ReturnType = @typeInfo(@TypeOf(work)).@"fn".return_type.?;
    var futures: [9]std.Io.Future(ReturnType) = undefined;
    for(0..9) |i| {
        const id = i + 1;
        const seconds = @as(i64, @intCast(1 + i % 3));
        futures[i] = io.*.async(work, .{io, id, seconds});
    }

    for(&futures) |*future| {
        _ = try future.await(io.*);
    }
}

pub fn main(init: std.process.Init) !void {
    var single = std.Io.Threaded.init_single_threaded;
    defer single.deinit();
    var io: std.Io = single.io();
    std.log.info("single threaded io:", .{});
    try scheduler(&io);

    var pool = std.Io.Threaded.init(init.gpa,.{});
    defer pool.deinit();
    io = pool.io();
    std.log.info("thread pool io:", .{});
    try scheduler(&io);

    // we need out-pointer this one.
    var evented: std.Io.Evented = undefined;
    _ = try std.Io.Evented.init(&evented, init.gpa,.{});
    defer evented.deinit();
    io = evented.io();
    std.log.info("evented io:", .{});
    try scheduler(&io);
}

