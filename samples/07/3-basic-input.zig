// 3-basic-input.zig

const std = @import("std");

pub fn main(init: std.process.Init) !void {
    // the secret number to guess
    const number = 4;
    std.log.debug("Guess the number:",.{} );
    // setup io subsystem
    const io = init.io;
    var buf: [32]u8 = [_]u8{0} ** 32;
    const stdin = std.Io.File.stdin();
    var reader = stdin.reader(io, &buf);
    // call the reader
    const guess = try reader.interface.takeDelimiter('\n') orelse "";
    // convert the string into number
    const result = try std.fmt.parseInt(u8, guess, 10);
    std.log.debug("Number: {}, Result: {}",.{number, result});

}
