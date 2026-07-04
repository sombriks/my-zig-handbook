const std = @import("std");

const sqlite = @import("sqlite");

pub fn main(_: std.process.Init) !u8 {
    var db: ?*sqlite.sqlite3 = null;

    var rc = sqlite.sqlite3_open("example.db", &db);
    defer _ = sqlite.sqlite3_close(db);
    if (rc != sqlite.SQLITE_OK) {
        std.log.err("Can't open database: {s}", .{sqlite.sqlite3_errmsg(db)});
        return 1;
    }

    var errMsg: [*c]u8 = undefined;
    rc = sqlite.sqlite3_exec(db, "select 1 + 1", null, null, &errMsg);
    if (rc != sqlite.SQLITE_OK) {
        std.debug.print("SQL error: {s}\n", .{errMsg});
        sqlite.sqlite3_free(errMsg);
        return 1;
    }

    return 0;
}
