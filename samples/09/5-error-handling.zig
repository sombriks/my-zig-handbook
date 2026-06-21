// 5-error-handling.zig

const std = @import("std");

// let's invent some errors
const Err = error{OhNo, OhGod};

// our function might produce errors
fn roulette(number: u128) !void {
    if(number % 6 == 0) return Err.OhNo;
    if(number % 11 == 0) return Err.OhGod;
}

pub fn main() void {
    for(0..100) |i| {
        roulette(i) catch |err| {
            // deal with each error type
            switch(err) {
                Err.OhGod => std.log.warn("{} at {}", .{err, i}),
                else => std.log.warn("{} at {}", .{err, i})
            }
        };
    }
}
