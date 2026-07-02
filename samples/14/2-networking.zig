// 2-networking.zig

const std = @import("std");

const Io = std.Io;
const net = std.Io.net;
const IpAddress = net.IpAddress;

fn udpServer(io: Io, addr: IpAddress) !void {
    var socket = try addr.bind(io, .{
        .mode = .dgram,
        .protocol = .udp,
    });
    defer socket.close(io);

    std.log.info("Server UDP listening at {any}", .{addr});

    var buffer: [1024]u8 = undefined;
    while (true) {
        const msg = try socket.receive(io, &buffer);
        std.log.info("Received: '{s}' from {any}", .{ msg.data, msg.from });

        // just echo back
        try socket.send(io, &msg.from, msg.data);

        if (std.mem.eql(u8, msg.data, "end")) break;
    }
}

fn udpClient(io: Io, server_addr: IpAddress) !void {
    const any_addr = try IpAddress.parse("127.0.0.1", 0);
    var socket = try any_addr.bind(io, .{
        .mode = .dgram,
        .protocol = .udp,
    });
    defer socket.close(io);

    const msg_text = "Hello from Zig 0.16!";
    try socket.send(io, &server_addr, msg_text);
    std.log.info("Client sent: '{s}'", .{msg_text});

    var buffer: [1024]u8 = undefined;
    const response = try socket.receive(io, &buffer);
    std.log.info("Client received: '{s}'", .{response.data});

    try socket.send(io, &server_addr, "end");
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const addr = try IpAddress.parse("127.0.0.1", 9999);

    var server_task = io.async(udpServer, .{ io, addr });
    var client_task = io.async(udpClient, .{ io, addr });

    try server_task.await(io);
    try client_task.await(io);
}
