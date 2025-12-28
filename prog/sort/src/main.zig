extern var begin_signature: u32;
extern var end_signature: u32;

pub export var tohost: u32 linksection(".tohost") = 0;
pub export var fromhost: u32 linksection(".fromhost") = 0;

fn spike_exit(status: u32) noreturn {
    tohost = status;
    while (true) {}
}

pub export fn main() linksection(".text.main") noreturn {
    const start: usize = @intFromPtr(&begin_signature);
    const end: usize = @intFromPtr(&end_signature);
    const word_cnt: u32 = (end - start) / @sizeOf(u32);
    _ = word_cnt;

    var ptr: [*]volatile u32 = @as([*]volatile u32, @ptrFromInt(start));
    var arr = [_]u8{ 0, 2, 4, 6, 8, 10, 1, 3, 5, 7, 9 };

    for (arr, 0..) |_, idx1| {
        var min_idx = idx1;
        for (arr[(idx1 + 1)..], (idx1 + 1)..) |item2, idx2| {
            if (arr[min_idx] > item2) {
                min_idx = idx2;
            }
        }
        if (min_idx != idx1) {
            const tmp = arr[min_idx];
            arr[min_idx] = arr[idx1];
            arr[idx1] = tmp;
        }
    }

    for (arr, 0..) |item, idx| ptr[idx] = item;

    spike_exit(1);
}
