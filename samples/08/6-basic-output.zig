// 6-basic-output.zig

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const cwd = std.Io.Dir.cwd();
    // given this nice string
    const hello = "😄🎵▒🕹🌊▒🖳🧸▒";
    std.log.info("{s}, length {}", .{ hello, hello.len });
    // let's write it to a file
    try cwd.writeFile(io, .{ .sub_path = "sample-unicode.txt", .data = hello });
    // and read it back
    var buffer: [hello.len]u8 = undefined;
    _ = try cwd.readFile(io, "sample-unicode.txt", &buffer);
    std.log.info("read back as {s}", .{buffer});
    // get the size in unicode codepoints
    const size = try std.unicode.utf8CountCodepoints(&buffer);
    std.log.info("number of letters: {}", .{size});

    // loop over each unicode codepoint, one at a time
    var utf8_view = try std.unicode.Utf8View.init(&buffer);
    var iterator = utf8_view.iterator();
    var i: usize = 0;
    while (iterator.nextCodepointSlice()) |codepoint| {
        std.log.info("Codepoint {d}: {s}", .{ i, codepoint });
        i += 1;
    }
}
