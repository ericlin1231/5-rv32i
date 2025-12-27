extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

extern fn write_u32(ptr_ref: **volatile u32, val: u32) callconv(.c) void;
// extern fn write_u16(ptr_ref: **volatile u16, val: u16) callconv(.c) void;
// extern fn write_u8(ptr_ref: **volatile u8, val: u8) callconv(.c) void;
extern fn xor_u32(ptr_ref: **volatile u32, val: u32, times: u32) callconv(.c) void;
extern fn sra_u32(ptr_ref: **volatile u32, val: u32, shift_width: usize, amount: u32) callconv(.c) void;
extern fn srl_u32(ptr_ref: **volatile u32, val: u32, shift_width: usize, amount: u32) callconv(.c) void;
extern fn sll_u32(ptr_ref: **volatile u32, val: u32, shift_width: usize, amount: u32) callconv(.c) void;

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() linksection(".text.main") noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const word_cnt: u32 = (end - start) / @sizeOf(u32);
    _ = word_cnt; // autofix

    var raw: *volatile u32 = @as(*volatile u32, @ptrFromInt(start));

    const magic: u32 = 0xDEADBEEF;
    const sep: u32 = 0xAAAAAAAA;

    // xor self with same value for even times should has same value
    xor_u32(&raw, magic, 1024);
    write_u32(&raw, sep);
    // shift right arithemetic 4 bit for 8 times
    sra_u32(&raw, magic, 4, 8);
    write_u32(&raw, sep);
    // shift right logical 4 bit for 8 times
    srl_u32(&raw, magic, 4, 8);
    write_u32(&raw, sep);
    // shift left logical 4 bit for 8 times
    sll_u32(&raw, magic, 4, 8);
    write_u32(&raw, sep);

    spike_exit(1);
}
