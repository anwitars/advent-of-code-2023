use std::io::Read;

enum OrderInLine {
    First,
    Last,
}

struct Digit {
    letters: String,
    number: u8,
}

impl Digit {
    fn new(letters: impl AsRef<str>, number: u8) -> Self {
        Digit {
            letters: letters.as_ref().to_owned(),
            number,
        }
    }

    fn index_in_line(&self, line: impl AsRef<str>, which: &OrderInLine) -> Option<usize> {
        let mut line = line.as_ref().to_owned();
        if let OrderInLine::Last = which {
            line = line.chars().rev().collect::<String>();
        }

        let mut first_index = None;

        fn search_and_set_index<'a>(
            line: &str,
            letters: impl AsRef<str>,
            which: &OrderInLine,
            first_index: &mut Option<usize>,
        ) {
            let mut letters = letters.as_ref().to_owned();
            if let OrderInLine::Last = which {
                letters = letters.chars().rev().collect::<String>();
            }

            if let Some(index) = line.find(&letters) {
                if first_index.is_none() {
                    *first_index = Some(index);
                } else if let Some(first_index_value) = first_index {
                    if index < *first_index_value {
                        *first_index = Some(index);
                    }
                }
            }
        }

        search_and_set_index(&line, &self.letters, which, &mut first_index);
        search_and_set_index(&line, &self.number.to_string(), which, &mut first_index);

        first_index
    }
}

fn get_digit(line: impl AsRef<str>, digits: &[Digit], which: &OrderInLine) -> Option<u8> {
    let mut first_digit = None;
    let mut first_digit_index = None;

    // TODO: kind of the same as in Digit::index_in_line, maybe refactor later
    for digit in digits {
        if let Some(index) = digit.index_in_line(line.as_ref(), which) {
            if first_digit_index.is_none() {
                first_digit = Some(digit.number);
                first_digit_index = Some(index);
            } else if let Some(first_digit_index_value) = first_digit_index {
                if index < first_digit_index_value {
                    first_digit = Some(digit.number);
                    first_digit_index = Some(index);
                }
            }
        }
    }

    first_digit
}

fn main() -> std::io::Result<()> {
    let mut input = String::new();
    std::io::stdin().read_to_string(&mut input)?;

    let digits: [Digit; 10] = [
        Digit::new("zero", 0),
        Digit::new("one", 1),
        Digit::new("two", 2),
        Digit::new("three", 3),
        Digit::new("four", 4),
        Digit::new("five", 5),
        Digit::new("six", 6),
        Digit::new("seven", 7),
        Digit::new("eight", 8),
        Digit::new("nine", 9),
    ];

    let mut sum = 0;

    for line in input.lines() {
        let first_digit = get_digit(line, &digits, &OrderInLine::First).unwrap();
        let last_digit = get_digit(line, &digits, &OrderInLine::Last).unwrap();

        let double_digit = first_digit * 10 + last_digit;

        sum += double_digit as usize;
    }

    println!("Sum: {}", sum);

    Ok(())
}
