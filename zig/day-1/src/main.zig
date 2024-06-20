const std = @import("std");

const Digit = struct {
    letters: []const u8,
    value: u8,
};

const DIGITS = [_]Digit{
    .{ .letters = "zero", .value = 0 },
    .{ .letters = "one", .value = 1 },
    .{ .letters = "two", .value = 2 },
    .{ .letters = "three", .value = 3 },
    .{ .letters = "four", .value = 4 },
    .{ .letters = "five", .value = 5 },
    .{ .letters = "six", .value = 6 },
    .{ .letters = "seven", .value = 7 },
    .{ .letters = "eight", .value = 8 },
    .{ .letters = "nine", .value = 9 },
};

fn stringify_digit(digit: u8, buf: []u8) void {
    _ = std.fmt.bufPrint(buf, "{d}", .{digit}) catch {
        unreachable;
    };
}

fn get_double_digits_in_line(line: []const u8) !u8 {
    var first_digit: u8 = 0;
    var first_digit_index: ?usize = null;
    var last_digit: ?u8 = null;
    var last_digit_index: ?usize = null;

    for (DIGITS) |digit| {
        const first_index_of_digit_letter = std.mem.indexOf(u8, line, digit.letters);

        var stringified_digit: [1]u8 = undefined;
        _ = stringify_digit(digit.value, &stringified_digit);

        const first_index_of_digit = std.mem.indexOf(u8, line, &stringified_digit);

        const indexes_first = [_]?usize{ first_index_of_digit_letter, first_index_of_digit };
        for (indexes_first) |first_index_current| {
            if (first_index_current == null) {
                continue;
            }

            if (first_digit == 0) {
                first_digit = digit.value;
                first_digit_index = first_index_current;
            } else {
                if (first_index_current orelse unreachable <= first_digit_index orelse 999) {
                    first_digit = digit.value;
                    first_digit_index = first_index_current;
                }
            }
        }

        const last_index_of_digit_letter = std.mem.lastIndexOf(u8, line, digit.letters);
        const last_index_of_digit = std.mem.lastIndexOf(u8, line, &stringified_digit);

        const indexes_last = [_]?usize{ last_index_of_digit_letter, last_index_of_digit };
        for (indexes_last) |last_index_current| {
            if (last_index_current == null) {
                continue;
            }

            if (last_digit == null) {
                last_digit = digit.value;
                last_digit_index = last_index_current;
            } else {
                if (last_index_current orelse unreachable >= last_digit_index orelse 0) {
                    last_digit = digit.value;
                    last_digit_index = last_index_current;
                }
            }
        }
    }

    return first_digit * 10 + (last_digit orelse first_digit);
}

pub fn main() !void {
    const lines = try std.io.getStdIn().readToEndAlloc(std.heap.page_allocator, 1024 * 50);
    var sum: usize = 0;

    var iter = std.mem.split(u8, lines, "\n");

    while (iter.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const double_digit = try get_double_digits_in_line(line);
        sum += double_digit;
    }
    std.debug.print("Sum: {d}\n", .{sum});
}
