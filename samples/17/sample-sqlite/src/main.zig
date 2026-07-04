const std = @import("std");

const sqlite = @import("sqlite");

/// callback for query results. every cursor result will be passed here.
/// data: Passed directly from the 4th argument of sqlite3_exec
/// argc: Number of columns in the result row
/// argv: Array of strings representing column values
/// azColName: Array of strings representing column names
fn callback(_: ?*anyopaque, argc: i32, argv: [*c][*c]u8, azColName: [*c][*c]u8) callconv(.c) i32 {
    var i: usize = 0;
    var buf: [1024]u8 = undefined;
    var pos: usize = 0;

    while (i < @as(usize, @intCast(argc))) : (i += 1) {
        const col_name = if (azColName[i] != null) std.mem.span(azColName[i]) else "NULL";
        const val = if (argv[i] != null) std.mem.span(argv[i]) else "NULL";
        const item = std.fmt.bufPrint(buf[pos..], "{s}{s}: {s}", .{
            if (pos > 0) ", " else "",
            col_name,
            val,
        }) catch |err| {
            if (err == error.NoSpaceLeft) break;
            return 1;
        };
        pos += item.len;
    }
    std.log.info("{s}", .{buf[0..pos]});
    return sqlite.SQLITE_OK;
}

pub fn main(_: std.process.Init) !u8 {
    var db: ?*sqlite.sqlite3 = null;

    var rc = sqlite.sqlite3_open("example.db", &db);
    defer _ = sqlite.sqlite3_close(db);
    if (rc != sqlite.SQLITE_OK) {
        std.log.err("Can't open database: {s}", .{sqlite.sqlite3_errmsg(db)});
        return 1;
    }

    var errMsg: [*c]u8 = undefined;

    // let's do some SQL
    const sql =
        \\ select 1 + 1;
        \\ -- this is a comment
        \\ create table if not exists players(
        \\     id integer primary key autoincrement,
        \\     name text not null
        \\);
        \\ insert into players (name) values ('sombriks');
        \\ select * from players order by id desc;
        \\ select count(id) from players;
    ;
    rc = sqlite.sqlite3_exec(db, sql, callback, null, &errMsg);
    if (rc != sqlite.SQLITE_OK) {
        std.debug.print("SQL error: {s}\n", .{errMsg});
        sqlite.sqlite3_free(errMsg);
        return 1;
    }

    return 0;
}
