const std = @import("std");

pub const UART_BASE     : usize = 0x5000;
pub const UART_TX_BUF   : usize = UART_BASE + 0x0;
pub const UART_RX_BUF   : usize = UART_BASE + 0x4;
pub const UART_TX_READY : usize = UART_BASE + 0x8;
pub const UART_RX_VALID : usize = UART_BASE + 0xC;

pub inline fn ptr(comptime T: type, addr: usize) *volatile T {
    std.debug.assert(addr % @alignOf(T) == 0); // detect misalign access
    return @ptrFromInt(addr);
}

pub inline fn read(comptime T: type, addr: usize) T {
    return ptr(T, addr).*;
}

pub inline fn write(comptime T: type, addr: usize, value: T) void {
    ptr(T, addr).* = value;
}

pub inline fn read32(addr: usize) u32 {
    return read(u32, addr);
}

pub inline fn write32(addr: usize, value: u32) void {
    write(u32, addr, value);
}

