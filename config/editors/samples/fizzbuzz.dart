/// Prints "Fizz", "Buzz", or "FizzBuzz" for numbers from 1 to n.
/// - "Fizz" for numbers divisible by 3.
/// - "Buzz" for numbers divisible by 5.
/// - "FizzBuzz" for numbers divisible by both 3 and 5.
/// - Otherwise, prints the number itself.
void fizzBuzz(int n) {
  for (var i = 1; i <= n; i++) {
    if (i % 15 == 0) {
      print('FizzBuzz');
    } else if (i % 3 == 0) {
      print('Fizz');
    } else if (i % 5 == 0) {
      print('Buzz');
    } else {
      print(i);
    }
  }
}

void main() {
  fizzBuzz(15);
}
