extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

extern fn multi_load_store_u8(src: [*]const u8, dest: *[*]u8) callconv(.c) void;
// extern fn multi_load_store_u16(src: [*]const u16, dest: *[*]u16) callconv(.c) void;
// extern fn multi_load_store_u32(src: [*]const u32, dest: *[*]u32) callconv(.c) void;

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() linksection(".text.main") noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const word_cnt: u32 = (end - start) / @sizeOf(u32);
    _ = word_cnt;

    const src_u8 = [8]u8{ 0xEF, 0xBE, 0xAD, 0xDE, 0xBA, 0xDC, 0xCD, 0xAB };
    // const src_u16 = [4]u16{ 0xDEAD, 0xBEEF, 0xABCD, 0xDCBA };
    // const src_u32 = [2]u32{ 0xDEADBEEF, 0xABCDDCBA };

    var ptr_u8: [*]u8 = @ptrFromInt(start);
    multi_load_store_u8(src_u8[0..].ptr, &ptr_u8);
    // var ptr_u16: *u16 = @ptrCast(ptr_u8);
    // multi_load_store_u16(@ptrCast(&src_u16), &ptr_u16);
    // var ptr_u32: *u32 = @ptrCast(ptr_u16);
    // multi_load_store_u32(@ptrCast(&src_u32), &ptr_u32);

    spike_exit(1);
}
