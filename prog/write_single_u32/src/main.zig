extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

extern fn write_u32(ptr_ref: **volatile u32, val: u32) callconv(.c) void;

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() linksection(".text.main") noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const word_cnt: u32 = (end - start) / @sizeOf(u32);
    _ = word_cnt;

    var raw: *volatile u32 = @as(*volatile u32, @ptrFromInt(start));
    write_u32(&raw, 0xFFFFFFFF);

    spike_exit(1);
}
