// 3-networking.zig

const std = @import("std");
const http = std.http;
const Io = std.Io;
const net = Io.net;
const IpAddress = net.IpAddress;

fn httpClient(io: Io, allocator: std.mem.Allocator, addr: IpAddress) !void {
    // Wait for server
    io.sleep(Io.Duration.fromMilliseconds(100), .awake) catch {};

    var client = http.Client{
        .allocator = allocator,
        .io = io,
    };
    defer client.deinit();

    var uri_buf: [128]u8 = undefined;
    const uri_str = try std.fmt.bufPrint(&uri_buf, "http://127.0.0.1:{d}/", .{addr.getPort()});
    const uri = try std.Uri.parse(uri_str);

    var req = try client.request(.GET, uri, .{});
    defer req.deinit();

    try req.sendBodiless();

    var redirect_buffer: [1024]u8 = undefined;
    var response = try req.receiveHead(&redirect_buffer);

    std.log.info("Client received response: {d} {s}", .{@intFromEnum(response.head.status), response.head.reason});

    var body_buffer: [1024]u8 = undefined;
    var transfer_buffer: [1024]u8 = undefined;
    var body_reader = response.reader(&transfer_buffer);
    const n = try body_reader.readSliceShort(&body_buffer);

    std.log.info("Client received body: {s}", .{body_buffer[0..n]});
}

fn httpServer(io: Io, addr: IpAddress) !void {
    var srv = try addr.listen(io, .{ .reuse_address = true });
    defer srv.deinit(io);

    std.log.info("Server listening on {any}", .{addr});

    const stream = try srv.accept(io);
    defer stream.close(io);

    var in_buffer: [8192]u8 = undefined;
    var out_buffer: [1024]u8 = undefined;

    var reader_obj = stream.reader(io, &in_buffer);
    var writer_obj = stream.writer(io, &out_buffer);

    var server = http.Server.init(&reader_obj.interface, &writer_obj.interface);
    var req = try server.receiveHead();

    std.log.info("Server received request: {s} {s}", .{@tagName(req.head.method), req.head.target});

    try req.respond("Hello from Zig HTTP Server!\n", .{});
    std.log.info("Server responded and closing", .{});
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const addr = try IpAddress.parse("127.0.0.1", 8080);

    var server_task = io.async(httpServer, .{ io, addr });
    var client_task = io.async(httpClient, .{ io, init.gpa, addr });

    try server_task.await(io);
    try client_task.await(io);
}
