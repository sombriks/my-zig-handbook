// src/main.zig

const std = @import("std");
const pg = @import("pg");

pub fn main(init: std.process.Init) !void {
    // provision a connection pool
    const uri = try std.Uri.parse("postgresql://postgres:postgres@localhost:5432/sample");
    const pool = try pg.Pool.initUri(init.io, init.gpa, uri, .{ .size = 5, .timeout = 10_000 });
    defer pool.deinit();

    const sql =
        \\select 1 + 1
    ;

    // query the database
    var result = try pool.query(sql, .{});
    defer result.deinit();

    // loop the results
    while (try result.next()) |row| {
        const r = try row.get(i32, 0);
        std.log.info("query: {s}, result: {}", .{ sql, r });
    }

    // more operations
    const sql2 =
        \\create table if not exists players(
        \\  id serial primary key,
        \\  name text not null
        \\);
    ;
    _ = try pool.exec(sql2, .{});

    const sql3 = "insert into players (name) values ($1);";
    _ = try pool.exec(sql3, .{"sombriks"});

    const sql4 = "select * from players;";
    var result2 = try pool.query(sql4, .{});
    defer result2.deinit();

    while (try result2.next()) |p| {
        std.log.info("players({},{s})", .{ try p.get(i32, 0), try p.get([]u8, 1) });
    }
}
