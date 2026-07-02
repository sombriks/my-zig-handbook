// 1-networking.zig

const std = @import("std");
const Init = std.process.Init;
const IpAddress = std.Io.net.IpAddress;
const Server = std.Io.net.Server;

pub fn main(init: Init) !void {
    const addr = try IpAddress.parse("127.0.0.1",8080);
    var srv = try addr.listen(init.io,.{});
    defer srv.deinit(init.io);
    const stream = try srv.accept(init.io);
    stream.close(init.io);
}
