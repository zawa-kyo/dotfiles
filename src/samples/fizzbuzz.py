def fizz_buzz(n: int) -> None:
    """
    Prints "Fizz", "Buzz", or "FizzBuzz" for numbers from 1 to n.
    - "Fizz" for numbers divisible by 3.
    - "Buzz" for numbers divisible by 5.
    - "FizzBuzz" for numbers divisible by both 3 and 5.
    - Otherwise, prints the number itself.

    Args:
        n (int): The upper limit of the range (inclusive).
    """
    for i in range(1, n + 1):
        if i % 15 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)

# Test cases:
# - Correct: fizz_buzz(15)
# - Error: fizz_buzz("15") (Type hint error)
fizz_buzz(15)

# FIXME: Type hint error
fizz_buzz("15")
