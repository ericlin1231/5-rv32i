const uart = @import("uart.zig");

const data: []const u8 = "HELLO\n";

export fn main() noreturn {
    while (true) {
        uart.writeAll(data);
    }
}

