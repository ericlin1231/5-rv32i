const mmio = @import("mmio.zig");

pub const TX = struct {
    pub inline fn ready() bool {
        return mmio.read32(mmio.UART_TX_READY) == 1;
    }

    pub inline fn waitReady() void {
        while (!ready()) {}
    }

    pub inline fn writeByte(byte: u8) void {
        mmio.write32(mmio.UART_TX_BUF, @as(u32, byte));
    }
};

pub const RX = struct {
    pub inline fn ready() bool {
        return mmio.read32(mmio.UART_RX_VALID) == 1;
    }

    pub inline fn waitReady() void {
        while (!ready()) {}
    }

    pub inline fn readByte() u8 {
        return @truncate(mmio.read32(mmio.UART_RX_BUF));
    }
};

pub inline fn send(byte: u8) void {
    TX.waitReady();
    TX.writeByte(byte);
}

pub inline fn trySend(byte: u8) bool {
    if (!TX.ready()) return false;
    TX.writeByte(byte);
    return true;
}

pub inline fn recv() u8 {
    RX.waitReady();
    return RX.readByte();
}

pub inline fn tryRecv() ?u8 {
    if (!RX.ready()) return null;
    return RX.readByte();
}

pub fn writeAll(bytes: []const u8) void {
    for (bytes) |b| send(b);
}
