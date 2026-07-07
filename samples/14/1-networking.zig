// 1-networking.zig

const std = @import("std");

const Io = std.Io;
const Init = std.process.Init;
const IpAddress = std.Io.net.IpAddress;
const Server = std.Io.net.Server;

fn sampleServer(io: Io, addr: IpAddress) !void {
    std.log.info("prepare server", .{});
    var srv = try addr.listen(io, .{});
    defer srv.deinit(io);
    const stream = try srv.accept(io);
    defer stream.close(io);
    var buffer: [1024]u8 = @splat(0);
    var chunk: [1024]u8 = @splat(0);
    var reader_obj = stream.reader(io, &buffer);
    var reader = &reader_obj.interface;
    const read = try reader.readSliceShort(&chunk);
    std.log.info("server read {} bytes, data '{s}'", .{ read, chunk });
}

fn sampleClient(io: Io, addr: IpAddress) !void {
    std.log.info("prepare client", .{});
    var stream = try addr.connect(io, .{ .mode = .stream });
    defer stream.close(io);
    var buffer: [1024]u8 = @splat(0);
    var writer_obj = stream.writer(io, &buffer);
    var writer = &writer_obj.interface;
    try writer.writeAll("Hello from client");
    try writer.flush();
    std.log.info("client done", .{});
}

pub fn main(init: Init) !void {
    const addr = try IpAddress.parse("127.0.0.1", 8080);
    const io = init.io;

    var t1 = io.async(sampleServer, .{ io, addr });
    var t2 = io.async(sampleClient, .{ io, addr });

    try t1.await(io);
    try t2.await(io);
}
