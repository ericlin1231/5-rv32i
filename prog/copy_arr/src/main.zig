extern var begin_signature: usize;
extern var end_signature: usize;

pub export var tohost: u64 linksection(".tohost") = 0;
pub export var fromhost: u64 linksection(".fromhost") = 0;

fn spike_exit(status: usize) noreturn {
    const ptr: *volatile u64 = @ptrCast(&tohost);
    ptr.* = @as(u64, status);
    while (true) {}
}

pub export fn main() noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const len_words: usize = (end - start) / @sizeOf(u32);

    const raw: [*]volatile u32 = @as([*]volatile u32, @ptrFromInt(start));
    const p: []volatile u32 = raw[0..len_words];

    var i: usize = 0;
    while (i < p.len) : (i += 1) {
        p[i] = 0xDEADBEEF;
    }

    spike_exit(1);
}
