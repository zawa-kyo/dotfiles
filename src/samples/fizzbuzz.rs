/// Prints "Fizz", "Buzz", or "FizzBuzz" for numbers from 1 to n.
/// - "Fizz" for numbers divisible by 3.
/// - "Buzz" for numbers divisible by 5.
/// - "FizzBuzz" for numbers divisible by both 3 and 5.
/// - Otherwise, prints the number itself.
fn fizz_buzz(n: i32) {
    for i in 1..=n {
        if i % 15 == 0 {
            println!("FizzBuzz");
        } else if i % 3 == 0 {
            println!("Fizz");
        } else if i % 5 == 0 {
            println!("Buzz");
        } else {
            println!("{i}");
        }
    }
}

fn main() {
    fizz_buzz(15);
}
