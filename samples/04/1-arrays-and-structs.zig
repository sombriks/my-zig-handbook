// 1-arrays-and-structs.zig
const xpto = @import("std");

pub fn main() void {
    //basic array usage
    var numbers = [5]u8{1,2,3,4,5};
    xpto.log.info("numbers {any}", .{numbers});
    numbers[0] = 20;
    xpto.log.info("numbers[0] {}", .{numbers[0]});
    // array size inference
    const numbers2 = [_]u8 {10,11,23};
    xpto.log.info("numbers2 {any}", .{numbers2});
    // array concatenation
    const numbers3 = numbers ++ numbers2;
    xpto.log.info("numbers3 {any}", .{numbers3});
    xpto.log.info("type of numbers3 {}", .{@TypeOf(numbers3)});
    xpto.log.info("size of numbers3 {}", .{@sizeOf(@TypeOf(numbers3))});
    // array "multiplication"
    const numbers4 = [_]u16{2} ** 10;
    xpto.log.info("numbers4 {any}", .{numbers4});
    xpto.log.info("type of numbers4 {}", .{@TypeOf(numbers4)});
    xpto.log.info("size of numbers4 {}", .{@sizeOf(@TypeOf(numbers4))});
    xpto.log.info("length of numbers4 {}", .{numbers4.len});
    // slices
    const slice1 = numbers3[2..7];
    xpto.log.info("slice1 {any}", .{slice1});
    xpto.log.info("type of slice1 {}", .{@TypeOf(slice1)});
    xpto.log.info("size of slice1 {}", .{@sizeOf(@TypeOf(slice1))});
    xpto.log.info("length of slice1 {}", .{slice1.len});
    const slice2 = numbers3[6..];
    xpto.log.info("slice2 {any}", .{slice2});
    xpto.log.info("type of slice2 {}", .{@TypeOf(slice2)});
    xpto.log.info("size of slice2 {}", .{@sizeOf(@TypeOf(slice2))});
    xpto.log.info("length of slice2 {}", .{slice2.len});
}
