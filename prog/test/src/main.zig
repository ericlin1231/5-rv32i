const std = @import("std");

pub fn main() !void {
    const str1 = "Hello";
    const str2 = " you!";
    const str3 = try std.mem.concat(allocator, u8, &[_][]const u8{ str1, str2 });
    try stdout.print("{s}\n", .{str3});
    try stdout.flush();
}
