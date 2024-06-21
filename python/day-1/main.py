from __future__ import annotations

import sys
from dataclasses import dataclass
from typing import Generic, Literal, TypeVar

T = TypeVar("T")


@dataclass(frozen=True, slots=True)
class ValueWithIndex(Generic[T]):
    value: T
    index: int


@dataclass(frozen=True, slots=True)
class Digit:
    letters: str
    number: int


DIGITS = [
    Digit("zero", 0),
    Digit("one", 1),
    Digit("two", 2),
    Digit("three", 3),
    Digit("four", 4),
    Digit("five", 5),
    Digit("six", 6),
    Digit("seven", 7),
    Digit("eight", 8),
    Digit("nine", 9),
]

INPUT = sys.stdin.readlines()


def get_digit_from_line(line: str, which: Literal["first", "last"]) -> int:
    found_digit_letter: ValueWithIndex[int] | None = None
    found_digit_number: ValueWithIndex[int] | None = None

    if which == "last":
        # reverse the line
        line = line[::-1]

    for digit in DIGITS:
        digit_index = line.find(
            digit.letters if which == "first" else digit.letters[::-1]
        )
        if digit_index != -1 and (
            found_digit_letter is None or digit_index < found_digit_letter.index
        ):
            found_digit_letter = ValueWithIndex(digit.number, digit_index)

        digit_index = line.find(str(digit.number))
        if digit_index != -1 and (
            found_digit_number is None or digit_index < found_digit_number.index
        ):
            found_digit_number = ValueWithIndex(digit.number, digit_index)

    return next(  # get the first value
        iter(
            map(  # get the value out of the ValueWithIndex
                lambda item: item.value,
                sorted(  # sort by index, so we get the one that is first in the line
                    filter(  # we do not care about the None values
                        None, [found_digit_letter, found_digit_number]
                    ),
                    key=lambda value_with_index: value_with_index.index,
                ),
            )
        ),
    )


sum = 0
for line in INPUT:
    line = line.strip()

    first_digit = get_digit_from_line(line, "first")
    last_digit = get_digit_from_line(line, "last")

    double_digit = first_digit * 10 + last_digit

    sum += double_digit

print(f"Sum: {sum}")
