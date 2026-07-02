// 3-networking.zig

const std = @import("std");

fn httpClient(io: std.Io, addr: std.Io.net.IpAddress) !void {}

fn httpServer(io: std.Io, addr: std.Io.net.IpAddress) !void {}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const addr = try std.Io.net.IpAddress.parse("127.0.0.1", 8080);

    var server_task = io.async(httpServer, .{ io, addr });
    var client_task = io.async(httpClient, .{ io, addr });

    try server_task.await(io);
    try client_task.await(io);
}
